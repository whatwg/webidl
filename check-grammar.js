"use strict";
const Grammar = require("syntax-cli").Grammar;
const LLParsingTable = require("syntax-cli").LLParsingTable;
const jsdom = require("jsdom");
const fs = require("fs");

function getRulesFromDOM(window) {
    let rules = window.document.querySelectorAll("pre.grammar[id]");
    return [].map.call(rules, pre => pre.textContent);
}

function processRules(rules) {
    const REGEXP = /(\s*:\n\s*)|\b(integer|float|identifier|string|whitespace|comment|other)\b|(\s*\n\s*)|(ε)/g;
    return rules.map(rule => {
        return rule.trim().replace(REGEXP, m => {
            if (/^(integer|float|identifier|string|whitespace|comment|other)$/.test(m)) {
              return m.toUpperCase();
            }
            if (/:\n/.test(m)) { return "\n  : "; }
            if (/\n/.test(m)) { return "\n  | "; }
            if (/ε/.test(m)) { return "/* epsilon */"; }
        }) + "\n  ;";
    });
}

function toBNF(rules) {
    return "\n%%\n\n" + processRules(rules).join("\n");
}

let path = process.argv[2];
let html = fs.readFileSync(path, "utf8");
let dom = new jsdom.JSDOM(html);
let rules = getRulesFromDOM(dom.window);
if (!rules.length) {
    console.log("Did not find any grammar snippets in the generated specification.");
    process.exit(1);
}
let bnf = toBNF(rules);
let data = Grammar.dataFromString(bnf, "bnf");
let grammar = Grammar.fromData(data, { mode: "LL1" });
let table = new LLParsingTable({ grammar: grammar });
let conflicts = table.getConflicts();
if (table.hasConflicts()) {
    console.log("The WebIDL grammar is NOT LL(1) due to the following conflicts:");
    Object.keys(conflicts).forEach((nt, i) => {
        let conflict = conflicts[nt];
        let str = Object.keys(conflict).map(k => `       * ${k} (${ conflict[k] })`).join("\n");
        console.log(`    ${i+1}. ${ nt }:\n${ str }`);
    });
    process.exit(1);
} else {
    console.log("The WebIDL grammar is LL(1).");
    process.exit(0);
}
