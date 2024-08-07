// Copyright 2024 The Gaea Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package function

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/XiaoMi/Gaea/tests/e2e/config"
	"github.com/XiaoMi/Gaea/tests/e2e/util"
	_ "github.com/go-sql-driver/mysql"
	"github.com/onsi/ginkgo/v2"
)

// test multi query
var _ = ginkgo.Describe("test unshard multi query", func() {
	e2eMgr := config.NewE2eManager()
	db := config.DefaultE2eDatabase
	slice := e2eMgr.NsSlices[config.SliceSingleMaster]
	table := config.DefaultE2eTable
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s",
		e2eMgr.GCluster.ReadWriteUser.UserName,
		e2eMgr.GCluster.ReadWriteUser.Password,
		e2eMgr.GCluster.Host,
		e2eMgr.GCluster.Port,
		db,
	)
	initNs, err := config.ParseNamespaceTmpl(config.DefaultNamespaceTmpl, slice)
	util.ExpectNoError(err, "parse namespace template")

	ginkgo.BeforeEach(func() {
		// mysql prepare
		masterAdminConn, err := slice.GetMasterAdminConn(0)
		util.ExpectNoError(err, "get master admin conn")
		err = util.SetupDatabaseAndInsertData(masterAdminConn, db, table)
		util.ExpectNoError(err, "setup database and insert data")

		// namespace prepare
		initNs.SupportMultiQuery = true
		err = e2eMgr.DeleteNamespace(initNs)
		util.ExpectNoError(err)
		initNs.Name = "test_unshard_multi_query"
		for i := 0; i < len(initNs.Users); i++ {
			initNs.Users[i].Namespace = initNs.Name
		}
		err = e2eMgr.ModifyNamespace(initNs)
		util.ExpectNoError(err, "create namespace")
		// wait mysql data  sync and namespace load
		time.Sleep(3 * time.Millisecond)
	})
	ginkgo.Context("handle multi query", func() {
		ginkgo.It("when gaea set supprt multiquery and client not set multi query", func() {
			gaeaReadWriteDB, err := sql.Open("mysql", dsn+"?multiStatements=false")
			util.ExpectNoError(err, "get gaea read write conn")
			defer gaeaReadWriteDB.Close()
			sql := fmt.Sprintf("select id from %s limit 1;select id,name from %s limit 1", table, table)
			rows, err := gaeaReadWriteDB.Query(sql)
			util.ExpectNoError(err, "query gaea", sql)
			defer rows.Close()
			for rows.Next() {
				var id int
				err = rows.Scan(&id)
				util.ExpectNoError(err)
				util.ExpectEqual(id, 1)
			}
			for rows.NextResultSet() {
				for rows.Next() {
					var id int
					var name string
					err = rows.Scan(&id, &name)
					util.ExpectNoError(err)
					util.ExpectEqual(id, 1)
					util.ExpectEqual(name, "nameValue")
				}
			}
		})

		ginkgo.It("when gaea set supprt multiquery and client set multi query", func() {
			gaeaReadWriteDB, err := sql.Open("mysql", dsn+"?multiStatements=true")
			util.ExpectNoError(err, "get gaea read write conn")
			defer gaeaReadWriteDB.Close()
			sql := fmt.Sprintf("select id from %s limit 1;select id,name from %s limit 1", table, table)
			rows, err := gaeaReadWriteDB.Query(sql)
			util.ExpectNoError(err, "query gaea", sql)
			defer rows.Close()
			for rows.Next() {
				var id int
				err = rows.Scan(&id)
				util.ExpectNoError(err)
				util.ExpectEqual(id, 1)
			}
			for rows.NextResultSet() {
				for rows.Next() {
					var id int
					var name string
					err = rows.Scan(&id, &name)
					util.ExpectNoError(err)
					util.ExpectEqual(id, 1)
					util.ExpectEqual(name, "nameValue")
				}
			}
		})

		ginkgo.It("when gaea not set supprt multiquery and client not set multi query", func() {
			initNs.SupportMultiQuery = false
			err = e2eMgr.ModifyNamespace(initNs)
			util.ExpectNoError(err, "create namespace")
			// wait mysql data  sync and namespace load
			time.Sleep(3 * time.Millisecond)

			gaeaReadWriteDB, err := sql.Open("mysql", dsn+"?multiStatements=false")
			util.ExpectNoError(err, "get gaea read write conn")
			defer gaeaReadWriteDB.Close()
			sql := fmt.Sprintf("select id from %s limit 1;select id,name from %s limit 1", table, table)
			rows, err := gaeaReadWriteDB.Query(sql)
			util.ExpectNoError(err, "query gaea", sql)
			defer rows.Close()
			for rows.Next() {
				var id int
				err = rows.Scan(&id)
				util.ExpectNoError(err)
				util.ExpectEqual(id, 1)
			}
			for rows.NextResultSet() {
				for rows.Next() {
					var id int
					var name string
					err = rows.Scan(&id, &name)
					util.ExpectNoError(err)
					util.ExpectEqual(id, 1)
					util.ExpectEqual(name, "nameValue")
				}
			}
		})

		ginkgo.It("when gaea not set supprt multiquery and client set multi query", func() {
			initNs.SupportMultiQuery = false
			err = e2eMgr.ModifyNamespace(initNs)
			util.ExpectNoError(err, "create namespace")
			// wait mysql data  sync and namespace load
			time.Sleep(3 * time.Millisecond)

			gaeaReadWriteDB, err := sql.Open("mysql", dsn+"?multiStatements=true")
			util.ExpectNoError(err, "get gaea read write conn")
			defer gaeaReadWriteDB.Close()
			sql := fmt.Sprintf("select id from %s limit 1;select id,name from %s limit 1", table, table)
			rows, err := gaeaReadWriteDB.Query(sql)
			util.ExpectNoError(err, "query gaea", sql)
			defer rows.Close()
			for rows.Next() {
				var id int
				err = rows.Scan(&id)
				util.ExpectNoError(err)
				util.ExpectEqual(id, 1)
			}
			for rows.NextResultSet() {
				for rows.Next() {
					var id int
					var name string
					err = rows.Scan(&id, &name)
					util.ExpectNoError(err)
					util.ExpectEqual(id, 1)
					util.ExpectEqual(name, "nameValue")
				}
			}
		})

		ginkgo.It("when gaea not set supprt multiquery and client set multi query insert", func() {
			initNs.SupportMultiQuery = false
			err = e2eMgr.ModifyNamespace(initNs)
			util.ExpectNoError(err, "create namespace")
			// wait mysql data  sync and namespace load
			time.Sleep(3 * time.Millisecond)

			masterAdminConn, err := slice.GetMasterAdminConn(0)
			util.ExpectNoError(err)
			util.SetupDatabaseAndInsertData(masterAdminConn, db, table)
			gaeaReadWriteDB, err := sql.Open("mysql", dsn+"?multiStatements=true")
			util.ExpectNoError(err)
			_, err = gaeaReadWriteDB.Exec(fmt.Sprintf("INSERT INTO %s.%s (`id`, `name`) VALUES ('101', 'aaa');INSERT INTO %s.%s (`id`, `name`) VALUES ('102', 'bbb');", db, table, db, table))
			util.ExpectNoError(err)
		})
	})

	ginkgo.AfterEach(func() {
		e2eMgr.Clean()
	})
})
