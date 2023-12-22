package function

import (
	_ "embed"
	"fmt"
	"github.com/XiaoMi/Gaea/tests/e2e/config"
	"github.com/XiaoMi/Gaea/tests/e2e/util"
	"github.com/onsi/ginkgo/v2"
	"github.com/onsi/gomega"
	"time"
)

var _ = ginkgo.Describe("test slave fuse", func() {
	e2eMgr := config.NewE2eManager()
	db, table := e2eMgr.Db, e2eMgr.Table
	slice := e2eMgr.NsSlices[config.SliceMasterSlaves]
	initNs, err := config.ParseNamespaceTmpl(config.DefaultNamespaceTmpl, slice)
	masterAdminConn, err := slice.GetMasterAdminConn(0)
	util.ExpectNoError(err, "get master admin conn")

	ginkgo.BeforeEach(func() {
		err = e2eMgr.NsManager.ModifyNamespace(initNs)
		util.ExpectNoError(err, "create namespace")
		err = util.SetupDatabaseAndInsertData(masterAdminConn, db, table)
		util.ExpectNoError(err, "setup database and insert data")
	})

	ginkgo.It("slave will not fuse when no privilege to show slave status", func() {
		e2eMgr.StartTime = time.Now()
		// step1: revoke mysql cluster privilege
		_, err = masterAdminConn.Exec(fmt.Sprintf(`REVOKE REPLICATION SLAVE, REPLICATION CLIENT ON *.* from '%s'@'%%'`, slice.Slices[0].UserName))
		util.ExpectNoError(err, "revoke replication slave")

		// step2: change cluster master to Gaea config slave, cluster slave to Gaea config master for test.
		sql := fmt.Sprintf("SELECT /*check slave fuse*/ * FROM %s.%s WHERE `id`= 1", db, table)
		counts := 30
		ns := initNs
		// set slave to one slave for checking log
		ns.Slices[0].Slaves = []string{slice.Slices[0].Slaves[0]}
		ns.SecondsBehindMaster = 10
		err = e2eMgr.NsManager.ModifyNamespace(ns)
		util.ExpectNoError(err, "modify namespace")

		// step3: continue query and check the query distribution.
		gaeaReadConn, err := e2eMgr.GetReadGaeaUserConn()
		util.ExpectNoError(err)
		for i := 0; i < counts; i++ {
			_, err := gaeaReadConn.Exec(sql)
			util.ExpectNoError(err)
			time.Sleep(1 * time.Second)
		}

		// step4: check the gaea log for distribution.
		res, err := e2eMgr.SearchLog(sql, e2eMgr.StartTime)
		util.ExpectNoError(err)
		gomega.Expect(res).Should(gomega.HaveLen(counts))
		for _, r := range res {
			gomega.Expect(ns.Slices[0].Slaves[0]).Should(gomega.Equal(r.BackendAddr))
		}

		// step5: reset mysql cluster privilege
		_, err = masterAdminConn.Exec(fmt.Sprintf(`GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* to '%s'@'%%'`, slice.Slices[0].UserName))
		util.ExpectNoError(err, "grant replication slave")
	})

	ginkgo.It("slave will not fuse when show slave status is empty", func() {
		e2eMgr.StartTime = time.Now()
		// step1: change cluster master to Gaea config slave, cluster slave to Gaea config master for test.
		ns := initNs
		ns.Slices[0].Master = slice.Slices[0].Slaves[0]
		ns.Slices[0].Slaves = []string{slice.Slices[0].Master}
		ns.SecondsBehindMaster = 10
		err = e2eMgr.NsManager.ModifyNamespace(ns)
		util.ExpectNoError(err, "modify namespace")

		// step3: continue query and check the query distribution.
		sql := fmt.Sprintf("SELECT /*check slave fuse*/ * FROM %s.%s WHERE `id`= 1", db, table)
		counts := 30
		gaeaReadConn, err := e2eMgr.GetReadGaeaUserConn()
		util.ExpectNoError(err)
		for i := 0; i < counts; i++ {
			_, err := gaeaReadConn.Exec(sql)
			util.ExpectNoError(err)
			time.Sleep(1 * time.Second)
		}

		// step4: check the gaea log for distribution.
		res, err := e2eMgr.SearchLog(sql, e2eMgr.StartTime)
		util.ExpectNoError(err)
		gomega.Expect(res).Should(gomega.HaveLen(counts))
		for _, r := range res {
			gomega.Expect(ns.Slices[0].Slaves[0]).Should(gomega.Equal(r.BackendAddr))
		}
	})

	ginkgo.AfterEach(func() {
		e2eMgr.Clean()
	})
})
