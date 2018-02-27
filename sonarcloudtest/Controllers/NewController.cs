using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace sonarcloudtest.Controllers
{
    [Route("api/[controller]")]
    public class NewController : Controller
    {
        [HttpGet("[action]")]
        public IEnumerable<Ietm> Things()
        {
            var rng = new Random();
            var name = "John";
            if ("".Equals(name))
            {
                var wat = "How is this okay?";
            } else
            {
                var error = "FAIL!";
            }
            return Enumerable.Range(1, 5).Select(index => new Ietm
            {
                name = name + rng.Next()
            });
        }

        public class Ietm
        {
            public string name { get; set; }

            public int value
            {
                get
                {
                    return 33 * name.Length;
                }
            }
        }
    }
}
