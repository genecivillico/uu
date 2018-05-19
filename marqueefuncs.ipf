#pragma rtGlobals=1		// Use modern global access method.


menu "graphmarquee"
	"-"
	"List from marquee", marqlist()
	"Remove Waves", remwaves()
	"Add Legend", addlegend()
	"labelspks", labelspks()
	"deletemarq",deletemarq()
	"snip", snipfrommarq()
	"colors",colorselected()
	"removefromgraph", removetracesfromgraph()
end


//*************************************************************

function getmarqwaves()

variable /G vmax,vmin,xmax,xmin
getmarquee /K left,bottom
if(V_flag==0)
	print "No marquee"
else
	vmax=V_top
	vmin=V_bottom
	xmax=V_right
	xmin=V_left
endif

string wvlist=tracenamelist("",";",1)
variable numlist=itemsinlist(wvlist)
variable i,j
string tracename_str
string /G selwvlist=""

for(i=0;i<numlist;i+=1)
	tracename_str=stringfromlist(i,wvlist)
	WAVE thiswave=tracenametowaveref("",tracename_str)
	duplicate /O/R=(xmin,xmax) thiswave tempwave
	extract /O tempwave, destwave, tempwave>vmin&&tempwave<vmax
	if(numpnts(destwave)>0)
		selwvlist=addlistitem (tracename_str,selwvlist,";",inf)
		//print tracename_Str
	endif
	killwaves destwave
endfor

killwaves tempwave

end


Function marqlist ()

	variable i
	rootfolder()
	getmarqwaves()
	SVAR selwvlist	
	
	string nameofnumberlist, thiswave_str
	prompt nameofnumberlist, "name to use for list"
	doprompt "booyah", nameofnumberlist
		
	variable numlist=itemsinlist(selwvlist)
		
	make/O/n=(itemsinlist(selwvlist)) $(nameofnumberlist)	
	WAVE list = $(nameofnumberlist)
	
	for(i=0;i<numlist;i+=1)

		thiswave_str=stringfromlist(i,selwvlist)
		list[i] = getmvnumber(thiswave_str)
		//print list[i]
			
	endfor


end


//***************************************************************


function remwaves()

getmarqwaves()

SVAR selwvlist=selwvlist
variable numlist=itemsinlist(selwvlist)
variable i
string thiswave_str
for(i=0;i<numlist;i+=1)
	thiswave_str=stringfromlist(i,selwvlist)
	removefromgraph $thiswave_str
endfor

end


//********************************************************************


function addlegend()

getmarquee /K left, bottom
if(V_flag==0)
	print "No marquee"
else
	Legend/C/N=text0/F=0/A=MC
endif

end


//*************************************************************************

function deletemarq()

getmarqwaves()

SVAR selwvlist=selwvlist
variable num=itemsinlist(selwvlist)
NVAR xmax=xmax
NVAR xmin=xmin
variable i,startv
string thiswave_str
for(i=0;i<num;i+=1)
	thiswave_str=stringfromlist(i,selwvlist)
	wave thiswave=$thiswave_str
	startv=thiswave(xmin)
	thiswave[(x2pnt(thiswave,xmin)),(x2pnt(thiswave,xmax))]=startv
endfor

end

//*********************************************************************

function snipfrommarq ()

	getmarqwaves()
	SVAR selwvlist=selwvlist
	variable num=itemsinlist(selwvlist)
	NVAR xmax=xmax
	NVAR xmin=xmin
	variable i,startv
	string thiswave_str
	string newname
	
	String name
	Prompt name, "basename for created snips"
	DoPrompt "enter base name", name
	
	for(i=0;i<num;i+=1)
	
		thiswave_str=stringfromlist(i,selwvlist)
		newname = (thiswave_str + name)
		wave thiswave=$thiswave_str
		
		duplicate/o/R=(xmax,xmin) thiswave $newname
	
	endfor

end


function colorselected()
	
	Variable red,green,blue
	Prompt red, "red"
	Prompt green, "green"
	Prompt blue, "blue"
	DoPrompt "enter desired color", red, green, blue

	getmarqwaves()
	SVAR selwvlist
	variable num=itemsinlist(selwvlist)
	
	String tracename_str
	
	Variable i

	for(i=0;i<num;i+=1)
		tracename_str=stringfromlist(i,selwvlist)
		removefromgraph $tracename_str
		appendtograph $tracename_str
		modifygraph rgb($tracename_str)=(red,green,blue)
	endfor

end


function removetracesfromgraph()
	
	getmarqwaves()
	SVAR selwvlist
	variable num=itemsinlist(selwvlist)
	
	String tracename_str
	
	Variable i

	for(i=0;i<num;i+=1)
		tracename_str=stringfromlist(i,selwvlist)
		removefromgraph $tracename_str
	endfor

end
