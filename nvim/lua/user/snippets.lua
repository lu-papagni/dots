local ls = require("luasnip")
-- local extras = require("luasnip.extras")
-- local rep = extras.rep
local for_language = ls.add_snippets
local snippet = ls.snippet
-- local composite = ls.snippet_node
local text = ls.text_node
-- local insert = ls.insert_node

-- L'intestazione che vuole il prof di laboratorio di informatica
for_language("c", {
  snippet("labinfo-preamble", {
    text({
      "/* Autore: Papagni Luca",
      " * Stile di intentazione: Allman",
      " * Convenzione identificatori: camelCase",
      " */"
    })
  })
})
