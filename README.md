vim-dn-docbk
============

An auxiliary vim ftplugin for docbook.

Installation
------------

Install using vundle or pathogen.

Requires
--------

Vim plugin: [dn-utils](https://github.com/dnebauer/dn-vim-utils).

System default viewers: html and pdf output files are displayed using default system applications.

Sets filetype
-------------

This plugin sets the filetype to 'docbk' if the file has an '.xml' extension and a root element with a docbook5 xmlns attribute. \(Valid root elements are 'book', 'article', 'bibliography', 'chapter', 'index' or 'part'.\)

Note that the element opening tag and xmlns attribute must be on the same line.

This is an example:

```xml
<article xmlns="http://docbook.org/ns/docbook" version="5.0" xml:lang="en">
```

Provides
--------

This filetype plugin automates the following tasks:

###Generating html output using pandoc

*   mapping: `<LocalLeader>gh`

*   command: `GenerateHTML`

###Viewing html output with system default html viewer

*   mapping: `<LocalLeader>vh`

*   command: `ViewHTML`

###Generating pdf output using pandoc and lualatex

*   mapping: `<LocalLeader>gp`

*   command: `GeneratePDF`

###Viewing pdf output with system default pdf viewer

*   mapping: `<LocalLeader>vp`

*   command: `ViewPDF`

###Customisation of output

Specify stylesheet for html output with the `DNM_SetStyle(stylesheet_filepath)` function.

Specify pandoc output template for html \[`DNM_SetHtmlTemplate(template_filepath)`\] and pdf `\[DNM_SetPdfTemplate(template_filepath)\]`.

Use or remove pandoc-citeproc filter with functions `DNM_PandocCiteproc` and `DNM_NoPandocCiteproc`.

Credit
------

The style file is a thin wrapping of Ryan Gray's buttondown css stylesheet hosted at [github](https://github.com/ryangray/buttondown).
