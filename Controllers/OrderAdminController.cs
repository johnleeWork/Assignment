using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Ass.Models;

namespace Ass.Controllers
{
    public class OrderAdminController : Controller
    {
        private ASSCEntities db = new ASSCEntities();

        // GET: OrderAdmin
        public ActionResult Index()
        {
            var tblOrders = db.tblOrders.Include(t => t.tblUser);
            return View(tblOrders.ToList());
        }

        // GET: OrderAdmin/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            //tblOrder tblOrder = db.tblOrders.Find(id);
            var tblOrderDetail = db.tblOrderDetails.Include(t => t.tblOrder);
            if (tblOrderDetail == null)
            {
                return HttpNotFound();
            }
            return View(tblOrderDetail.ToList());
        }

        // GET: OrderAdmin/Create
        public ActionResult Create()
        {
            ViewBag.userID = new SelectList(db.tblUsers, "userID", "name");
            return View();
        }

        // POST: OrderAdmin/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "orderID,userID,total,dateBuy,address")] tblOrder tblOrder)
        {
            if (ModelState.IsValid)
            {
                db.tblOrders.Add(tblOrder);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.userID = new SelectList(db.tblUsers, "userID", "name", tblOrder.userID);
            return View(tblOrder);
        }

        // GET: OrderAdmin/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tblOrder tblOrder = db.tblOrders.Find(id);
            if (tblOrder == null)
            {
                return HttpNotFound();
            }
            ViewBag.userID = new SelectList(db.tblUsers, "userID", "name", tblOrder.userID);
            return View(tblOrder);
        }

        // POST: OrderAdmin/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "orderID,userID,total,dateBuy,address")] tblOrder tblOrder)
        {
            if (ModelState.IsValid)
            {
                db.Entry(tblOrder).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.userID = new SelectList(db.tblUsers, "userID", "name", tblOrder.userID);
            return View(tblOrder);
        }

        // GET: OrderAdmin/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tblOrder tblOrder = db.tblOrders.Find(id);
            if (tblOrder == null)
            {
                return HttpNotFound();
            }
            return View(tblOrder);
        }

        // POST: OrderAdmin/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            tblOrder tblOrder = db.tblOrders.Find(id);
            db.tblOrders.Remove(tblOrder);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
