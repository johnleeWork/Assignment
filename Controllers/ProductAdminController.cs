using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Ass.Models;
using PagedList;
using System.Linq.Dynamic; 
using System.Linq.Expressions;
using System.Reflection;

namespace Ass.Controllers
{
    public class ProductAdminController : Controller
    {
        private ASSCEntities db = new ASSCEntities();

        public class HttpParamActionAttribute : ActionNameSelectorAttribute
        {
            public override bool IsValidName(ControllerContext controllerContext, string actionName, MethodInfo methodInfo)
            {
                if (actionName.Equals(methodInfo.Name, StringComparison.InvariantCultureIgnoreCase))
                    return true;

                var request = controllerContext.RequestContext.HttpContext.Request;
                return request[methodInfo.Name] != null;
            }
        }

       
        public ActionResult Index(int? size, int? page, string sortProperty, string sortOrder, string searchString, int categoryID = 0)
        {

            var categories = from c in db.tblCategories select c;
            ViewBag.categoryID = new SelectList(categories, "categoryID", "name");
            

            // 1. Tạo biến ViewBag gồm sortOrder, searchValue, sortProperty và page
            if (sortOrder == "asc") ViewBag.sortOrder = "desc";
                if (sortOrder == "desc") ViewBag.sortOrder = "";
                if (sortOrder == "") ViewBag.sortOrder = "asc";
                ViewBag.searchValue = searchString;
                ViewBag.sortProperty = sortProperty;
                ViewBag.page = page;

                // 2. Tạo danh sách chọn số trang
                List<SelectListItem> items = new List<SelectListItem>();
                items.Add(new SelectListItem { Text = "5", Value = "5" });
                items.Add(new SelectListItem { Text = "10", Value = "10" });
                items.Add(new SelectListItem { Text = "20", Value = "20" });
                items.Add(new SelectListItem { Text = "25", Value = "25" });
                items.Add(new SelectListItem { Text = "50", Value = "50" });
                items.Add(new SelectListItem { Text = "100", Value = "100" });
                items.Add(new SelectListItem { Text = "200", Value = "200" });

                // 2.1. Thiết lập số trang đang chọn vào danh sách List<SelectListItem> items
                foreach (var item in items)
                {
                    if (item.Value == size.ToString()) item.Selected = true;
                }
                ViewBag.size = items;
                ViewBag.currentSize = size;

                // 3. Lấy tất cả tên thuộc tính của lớp Link (LinkID, LinkName, LinkURL,...)
                var properties = typeof(tblProduct).GetProperties();
                List<Tuple<string, bool, int>> list = new List<Tuple<string, bool, int>>();
                foreach (var item in properties)
                {
                    int order = 999;
                    var isVirtual = item.GetAccessors()[0].IsVirtual;

                    
                    if (item.Name == "name") order = 1;
                    if (item.Name == "Description") order = 2;
                    if (item.Name == "quantity") order = 3;
                    if (item.Name == "price") order = 4;
                    if (item.Name == "status") order = 5;
                    if (item.Name == "phoneID") continue;
                    if (item.Name == "categoryID") continue;
                    if (item.Name == "imagePath") continue;                    
                    if (item.Name == "tblCategory") continue; 
                    if (item.Name == "tblOrderDetails") continue; 
                    Tuple<string, bool, int> t = new Tuple<string, bool, int>(item.Name, isVirtual, order);
                    list.Add(t);
                }
                list = list.OrderBy(x => x.Item3).ToList();

                // 3.1. Tạo Heading sắp xếp cho các cột
                foreach (var item in list)
                {
                    if (!item.Item2)
                    {
                        if (sortOrder == "desc" && sortProperty == item.Item1)
                        {
                            ViewBag.Headings += "<th><a href='?page=" + page + "&size=" + ViewBag.currentSize + "&sortProperty=" + item.Item1 + "&sortOrder=" +
                                ViewBag.sortOrder + "&searchString=" + searchString + "'>" + item.Item1 + "<i class='fa fa-fw fa-sort-desc'></i></th></a></th>";
                        }
                        else if (sortOrder == "asc" && sortProperty == item.Item1)
                        {
                            ViewBag.Headings += "<th><a href='?page=" + page + "&size=" + ViewBag.currentSize + "&sortProperty=" + item.Item1 + "&sortOrder=" +
                                ViewBag.sortOrder + "&searchString=" + searchString + "'>" + item.Item1 + "<i class='fa fa-fw fa-sort-asc'></a></th>";
                        }
                        else
                        {
                            ViewBag.Headings += "<th><a href='?page=" + page + "&size=" + ViewBag.currentSize + "&sortProperty=" + item.Item1 + "&sortOrder=" +
                               ViewBag.sortOrder + "&searchString=" + searchString + "'>" + item.Item1 + "<i class='fa fa-fw fa-sort'></a></th>";
                        }

                    }
                    else ViewBag.Headings += "<th>" + item.Item1 + "</th>";
                }

                // 4. Truy vấn lấy tất cả đường dẫn
                //var product = from l in db.tblProducts
                //            select l;
            var product = db.tblProducts.Include(P => P.tblCategory);

            // 5. Tạo thuộc tính sắp xếp mặc định là "PhoneID"
            if (String.IsNullOrEmpty(sortProperty)) sortProperty = "name";

                // 5. Sắp xếp tăng/giảm bằng phương thức OrderBy sử dụng trong thư viện Dynamic LINQ
                if (sortOrder == "desc") product = product.OrderBy(sortProperty + " desc");
                else if (sortOrder == "asc") product = product.OrderBy(sortProperty);
            else product = product.OrderBy("name");

            // 5.1. Thêm phần tìm kiếm
            

            if (!String.IsNullOrEmpty(searchString))
                {
                product = product.Where(s => s.name.Contains(searchString));
                }

            if (categoryID != 0)
            {
                product = product.Where(x => x.categoryID == categoryID);
            }

            // 5.2. Nếu page = null thì đặt lại là 1.
            page = page ?? 1; //if (page == null) page = 1;

                // 5.3. Tạo kích thước trang (pageSize), mặc định là 5.
                int pageSize = (size ?? 5);

                ViewBag.pageSize = pageSize;

                // 6. Toán tử ?? trong C# mô tả nếu page khác null thì lấy giá trị page, còn
                // nếu page = null thì lấy giá trị 1 cho biến pageNumber. --- dammio.com
                int pageNumber = (page ?? 1);

                // 6.2 Lấy tổng số record chia cho kích thước để biết bao nhiêu trang
                int checkTotal = (int)(product.ToList().Count / pageSize) + 1;
                // Nếu trang vượt qua tổng số trang thì thiết lập là 1 hoặc tổng số trang
                if (pageNumber > checkTotal) pageNumber = checkTotal;

                // 7. Trả về các Link được phân trang theo kích thước và số trang.
                return View(product.ToPagedList(pageNumber, pageSize));
            
        }
        [HttpPost, HttpParamAction]
        public ActionResult Reset()
        {
            ViewBag.searchValue = "";
            Index(null, null, "", "", "",0);
            return View();
        }
        // GET: ProductAdmin/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tblProduct tblProduct = db.tblProducts.Find(id);
            if (tblProduct == null)
            {
                return HttpNotFound();
            }
            return View(tblProduct);
        }

        // GET: ProductAdmin/Create
        public ActionResult Create()
        {
            ViewBag.categoryID = new SelectList(db.tblCategories, "categoryID", "name");
            return View();
        }

        // POST: ProductAdmin/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "phoneID,name,Description,quantity,price,categoryID")] tblProduct tblProduct,HttpPostedFileBase imgfile)
        {
            if (ModelState.IsValid)
            {
                string path = uploadimage(imgfile);
                if (path.Equals("-1"))
                {

                }
                else
                {
                    tblProduct.imagePath = path;
                    tblProduct.status = true;
                    db.tblProducts.Add(tblProduct);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }                
            }

            ViewBag.categoryID = new SelectList(db.tblCategories, "categoryID", "name", tblProduct.categoryID);
            return View(tblProduct);
        }
        public string uploadimage(HttpPostedFileBase imgfile)
        {
            Random r = new Random();
            string path = "-1";
            int radom = r.Next();
            if(imgfile !=null && imgfile.ContentLength > 0)
            {
                string extension = Path.GetExtension(imgfile.FileName);
                if (extension.ToLower().Equals(".jpg") || extension.ToLower().Equals(".jpeg") || extension.ToLower().Equals(".png")){
                    try
                    {
                        path = Path.Combine(Server.MapPath("~/Content/upload"), radom + Path.GetFileName(imgfile.FileName));
                        imgfile.SaveAs(path);
                        path = "/Content/upload/" + radom + Path.GetFileName(imgfile.FileName);

                    }
                    catch(Exception ex)
                    {
                        path = "-1";
                    }
                }
                else {
                    Response.Write("<script>alert('Only jpg ,jpeg or png formats are acceptable.....'); </script>");
                }
            }
            else
            {
                Response.Write("<script>alert('Please select a file'); </script>");
            }
            return path;
        }

        // GET: ProductAdmin/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tblProduct tblProduct = db.tblProducts.Find(id);
            if (tblProduct == null)
            {
                return HttpNotFound();
            }
            ViewBag.categoryID = new SelectList(db.tblCategories, "categoryID", "name", tblProduct.categoryID);
            return View(tblProduct);
        }

        // POST: ProductAdmin/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "phoneID,name,Description,quantity,price,categoryID,imagePath,status")] tblProduct tblProduct, HttpPostedFileBase imgfile)
        {
            if (ModelState.IsValid)
            {
                string path = uploadimage(imgfile);
                if (path.Equals("-1"))
                {

                }
                else
                {
                    tblProduct.imagePath = path;
                    db.Entry(tblProduct).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                    
            }
            ViewBag.categoryID = new SelectList(db.tblCategories, "categoryID", "name", tblProduct.categoryID);
            return View(tblProduct);
        }

        // GET: ProductAdmin/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            tblProduct tblProduct = db.tblProducts.Find(id);
            if (tblProduct == null)
            {
                return HttpNotFound();
            }
            return View(tblProduct);
        }

        // POST: ProductAdmin/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            tblProduct tblProduct = db.tblProducts.Find(id);
            tblProduct.status = false;  
            db.Entry(tblProduct).State = EntityState.Modified;
            //db.tblProducts.Remove(tblProduct);
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
