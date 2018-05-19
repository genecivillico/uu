need to #pragma rtGlobals=1		// Use modern global access method.

// functions that constitute a system for dealing with wave notes

// Wave notes should be set up as keyword:value pairs

// enter a string for the value even if it's a number; use valueisnumber parameter to specify whether it is or not
Function noteKWV (theWave, keyword, valuestring, valueisnumber)
	WAVE theWave
	String keyword, valuestring
	Variable valueisnumber
	
	String oldNote = note(theWave)
	String appendtoNote = ""
	if (valueisnumber)
		appendtoNote = replacenumberbykey(keyword,oldNote, str2num(valuestring))
	else
		appendtoNote = replacestringbykey(keyword, oldNote, valuestring)
	endif
	
	Note/K theWave
	Note/NOCR theWAVE, appendtoNote
	
end

Function multiNoteKWV (theWave, listofkeystrings, listofvaluestrings, valueisnumberwave)
	WAVE theWave, valueisnumberwave
	String listofkeystrings, listofvaluestrings
	
	variable numkeywords = itemsinlist(listofkeystrings)
	variable numvaluestrings = itemsinlist(listofvaluestrings)
	
	if (numkeywords != numvaluestrings)
		abort "input error in multinoteKWV"
	endif
	
	variable i
	for (i=0; i < numkeywords; i += 1)
	
		noteKWV(theWave, StringFromList(i, listofkeystrings),StringFromList(i, listofvaluestrings), valueisnumberwave[i])
	
	endfor
	
end