#!/usr/bin/tclsh
#                          this is a -*-Tcl-*- file
package require tdom
package require Tk

# gives us [table] procedure
source file.tcl

if {[info commands lmap] != "lmap"} {
    source lmap.tcl
}

set NS {
    ts http://tokenscript.org/2020/06/tokenscript
    asnx urn:ietf:params:xml:ns:asnx
    ethereum urn:ethereum:constantinople
}

#--------- XPaths applied under each contrainers to get the columns

set xp-contract {
    {interface	Interface @interface}
    {addresses	Addresses string(ts:address)}
}

set xp-attribute {
    {label	Label	string(ts:label/ts:string/text())}
    {syntax	Syntax	string(ts:type/ts:syntax/text())}
    {origins	Origins	name(ts:origins/*)}
}

set xp-card {
    {type	Type	@type}
    {view-lang	View-Languages ts:view/@xml:lang}
}

set xp-dataObject {
    {elements	Elements //element/@name}
    {references	References count(//ethereum:event[@module=$name])}
}

set xp-localisation {
    {parent	Of	name(..)}
    {name	Name	../@name}
    {l10n	Localistaion string(.//ts:string)}
}

set xp-selection {
    {label	Label	string(ts:label/ts:string/text())}
    {filter	Filter	@filter}
}

#--------- UI elements that only need to be spawned once --------- 

menu .mbar
. configure -menu .mbar

menu .mbar.file
.mbar.file add command -label "New" -underline 0
.mbar.file add command -label "Open..." -underline 0 \
    -command { filemenu_open }

.mbar add cascade -menu .mbar.file -label File \
    -underline 0

.mbar.file add command -label Exit -command { exit }


pack [ttk::notebook .nb]
.nb add [frame .nb.f0] -text "Contracts"
.nb add [frame .nb.f1] -text "Token Attributes"
.nb add [frame .nb.f2] -text "Cards"
.nb add [frame .nb.f3] -text "Data Objects"
.nb add [frame .nb.f4] -text "Strings"
.nb add [frame .nb.f5] -text "Selection"

ttk::frame .status
ttk::label .status.filename -textvariable filename

pack .status.filename
pack .status

# $doc delete

#--------- process commandline parameters --------- 


if { $argc != 1 } {
    puts "If you supply a parameter, it will be taken as a TokenScript filename"
    puts "For example, try $argv0 examples/ENS/ENS.xml"
} else {
    set filename [lindex $argv 0]
    set fileid [open $filename r]
    doc_load $fileid
}

