local ls = require("luasnip")

-- L'intestazione che vuole il prof di laboratorio di informatica
ls.add_snippets("c", {
  ls.snippet("labinfo-preamble", {
    ls.text_node({
      "/* Autore: Papagni Luca",
      " * Stile di intentazione: Allman",
      " * Convenzione identificatori: camelCase",
      " */"
    })
  })
})
