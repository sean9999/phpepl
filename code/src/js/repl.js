;(function(window,document,$,undefined){
	"use strict";
	var mirror;
	var init = function(){
		initializeCodeMirror();
	};
	var resizeCodeMirror = function(){
		var css = window.getComputedStyle(document.querySelector('#codemirrorcontainer'));
		mirror.setSize(css.width, css.height);
	};
	var initializeCodeMirror = function(){
		mirror = CodeMirror.fromTextArea(document.getElementById('codemirrortextarea'),{
			lineNumbers: true,
			matchBrackets: true,
			mode: "application/x-httpd-php",
			indentUnit: 4,
			indentWithTabs: true,
			theme: "elegant",
			gutters: ["phperror-gutter", "CodeMirror-linenumbers"]
		});
		resizeCodeMirror();
	};

	//	moving wall
	var wallMoves = function(ev) {
		switch (ev.type) {
			case 'dragstart':
			ev.dataTransfer.effectAllowed = "move";
			ev.dataTransfer.dropEffect = "move";
			break;
			case 'dragend':
			resizePanes(ev.x);
			resizeCodeMirror();
			case 'dragenter':
			case 'dragover':
			ev.dataTransfer.effectAllowed = "move";
			ev.dataTransfer.dropEffect = "move";
			ev.preventDefault();
			break;
		}
	};
	var resizePanes = function(x){
		document.getElementById('codemirrorcontainer').style.width = x + 'px';
	};

	//	key bindings
	$(document).keydown(function(e) {
		// CMD + Enter or CTRL + Enter to run code
		if (e.which === 13 && (e.ctrlKey || e.metaKey)) {
			runCode();
			return false;
		}
	});
	$('form').on('submit',function(ev){
		ev.preventDefault();
		runCode();
	});
	var runCode = function(){
		var o = document.querySelector('output code.php');
		var sourcecode = mirror.getValue();
		var p = {
			"code": sourcecode
		};
		var jqxhr = $.post( "eval/index.php", p, function(data) {
			if (data.error === null) {
				o.classList.remove('error');
				o.textContent = data.result;
				mirror.clearGutter('phperror-gutter');
			} else {
				o.classList.add('error');
				o.textContent = '';
				$('<strong />').text( data.error.msg ).appendTo(o);
				mirror.setGutterMarker(data.error.line-1, 'phperror-gutter', document.createTextNode("☹"));
			}
		});
	};
	['dragenter','dragover','dragstart','dragend'].forEach(function(event){
		document.addEventListener(event,wallMoves);
	});
	document.addEventListener('DOMContentLoaded',init);
	window.addEventListener("resize",resizeCodeMirror);
})(window,document,jQuery);