using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace api_lambda_dotnet.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : ControllerBase
    {
        Dictionary<int, string> m_Values;

        public ValuesController()
        {
          m_Values = new Dictionary<int, string>();
          m_Values.Add(1, "value1");
          m_Values.Add(2, "value2");
        }

        // GET api/values
        [HttpGet]
        public IEnumerable<string> Get()
        {
            return m_Values.Values.ToArray<string>();
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            if (m_Values.Count >= id)
              return Ok(m_Values[id]);
            else
              return BadRequest();
        }

        // POST api/values
        [HttpPost]
        public IEnumerable<string> Post([FromBody]string value)
        {
          System.Console.WriteLine("POST Called with {0}", value);
          m_Values.Add(m_Values.Count + 1, value);
          foreach (var item in m_Values.Values)
          {
              System.Console.WriteLine("Returning {0}", item);
          }
          return m_Values.Values.ToArray<string>();
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public IActionResult Put(int id, [FromBody]string value)
        {
            if (id > 0 && id <= m_Values.Count)
            {
              m_Values[id] = value;
              return Ok(m_Values.Values.ToArray<string>());
            }
            else
              return BadRequest();
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            if (id > 0 && id <= m_Values.Count)
            {
              if (m_Values.Remove(id))
                return Ok(m_Values.Values.ToArray<string>());
              else
                return NotFound();
            }
            else
              return BadRequest();
        }
    }
}
