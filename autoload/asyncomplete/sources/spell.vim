" asyncomplete spell completor
" use spellsuggest()
scriptversion 4
scriptencoding utf-8

if get(g:, 'loaded_autoload_asyncomplete_sources_spell')
	finish
endif
let g:loaded_autoload_asyncomplete_sources_spell = 1
let s:save_cpo = &cpoptions
set cpoptions&vim

function asyncomplete#sources#spell#get_source_options(opts)
	return extend(extend({}, a:opts), {
				\ 'name': 'spell',
				\ 'completor': function('asyncomplete#sources#spell#completor'),
				\ 'refresh_pattern': '\m\c\([A-Z]\{2,}\|[A-Z]\+''[A-Z]\+\)$',
				\ 'allowlist': ['*'],
				\ })
endfunction

function asyncomplete#sources#spell#completor(opt, ctx) abort
	let l:typed = a:ctx['typed']
	let l:col = a:ctx['col']
	let pat = asyncomplete#sources#spell#get_source_options({}).refresh_pattern
	let l:kw = matchstr(l:typed, pat)
	let l:miss = spellbadword(l:kw)[1]
	if l:miss !=# '' && match(l:kw, '\m\c^[A-Z]\+$') == 0 && match(l:kw, '\m\C[A-Z]') != -1 " programming CamelCase
		let i = 2
		while l:miss !=# '' && match(l:kw, '\m\C[A-Z]') != -1
			let l:kw = matchstr(l:typed, '\m\C[A-Z][A-Za-z]\+$', i)
			if l:kw ==# ''
				let l:kw = matchstr(l:typed, '\m\C[A-Z][a-z]\+$')
				let l:miss = spellbadword(l:kw)[1]
				break
			endif
			let l:miss = spellbadword(l:kw)[1]
			let i += 1
		endwhile
	endif
	if l:miss ==# ''
		let l:matches = [#{word: l:kw, menu: "[spell:good]"}]
	else
		let l:matches = map(spellsuggest(l:kw),'#{word:v:val, menu: "[spell:' .. l:miss .. ']"}')
	endif
	let l:startcol = a:ctx['col'] - len(l:kw)
	call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches, 1)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
