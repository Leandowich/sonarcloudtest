using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Numerics;

namespace sonarcloudtest.Controllers
{
    [Route("api/[controller]")]
    public class NewController : Controller
    {
          [HttpGet("[action]")]
                                public IEnumerable<Ietm> Things()
        {
            var rng = new Random();
    return Enumerable.Range(1, 5).Select(index => new Ietm
    {
        name = "John" + rng.Next()
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
