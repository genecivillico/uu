#pragma rtGlobals=1		// Use modern global access method.


function eegquantiles_etc (listwave)
	wave listwave
	
	setdatafolder root:
	variable numpoints = numpnts(listwave),i
	variable medianfornormalization

	make/O/n=(numpoints) UPintervals_qn_median, UPintervals_qn_Q25, UPintervals_qn_Q75
	make/O/n=(numpoints) UPendtotrigUP_qn_median, UPendtotrigUP_qn_Q25, UPendtotrigUP_qn_Q75
	make/O/n=(numpoints) ALLtimesafterUPend_qn_median, ALLtimesafterUPend_qn_Q25, ALLtimesafterUPend_qn_Q75
	make/O/n=(numpoints) TRIGtimesafterUPend_qn_median, TRIGtimesafterUPend_qn_Q25, TRIGtimesafterUPend_qn_Q75

	string nextfolder
			
	for (i=0; i < numpoints; i += 1)

		setdatafolder root:
		setdatafolder $(num2str(listwave[i]))
			
		StatsQuantiles/Q UPintervals
		duplicate/O W_statsquantiles UPintervals_quant, UPintervals_quantnorm
		WAVE UPintervals_quant, UPintervals_quantnorm
		medianfornormalization = UPintervals_quant[%Median]
		UPintervals_quantnorm /= medianfornormalization
		root:UPintervals_qn_median[i] = UPintervals_quantnorm[%Median]
		root:UPintervals_qn_Q25[i] = UPintervals_quantnorm[%Q25]
		root:UPintervals_qn_Q75[i] = UPintervals_quantnorm[%Q75]
		
		// the following lines are needed to "clear" the wave references for the next iteration of the loop
		// see the red Warning in the help file for the Duplicate operation to understand this
		WAVE UPintervals_quant = $""
		WAVE UPintervals_quantnorm = $""

		StatsQuantiles/Q UPendtotrigUP
		duplicate/O W_statsquantiles UPendtotrigUP_quant, UPendtotrigUP_quantnorm
		WAVE UPendtotrigUP_quant, UPendtotrigUP_quantnorm
		UPendtotrigUP_quantnorm /= medianfornormalization
		root:UPendtotrigUP_qn_median[i] = UPendtotrigUP_quantnorm[%Median]
		root:UPendtotrigUP_qn_Q25[i] = UPendtotrigUP_quantnorm[%Q25]
		root:UPendtotrigUP_qn_Q75[i] = UPendtotrigUP_quantnorm[%Q75]
		
		WAVE UPendtotrigUP_quant = $""
		WAVE UPendtotrigUP_quantnorm = $""

		StatsQuantiles/Q ALLtimesafterUPend
		duplicate/O W_statsquantiles ALLtimesafterUPend_quant, ALLtimesafterUPend_quantnorm
		WAVE ALLtimesafterUPend_quant, ALLtimesafterUPend_quantnorm
		ALLtimesafterUPend_quantnorm /= medianfornormalization
		root:ALLtimesafterUPend_qn_median[i] = ALLtimesafterUPend_quantnorm[%Median]
		root:ALLtimesafterUPend_qn_Q25[i] = ALLtimesafterUPend_quantnorm[%Q25]
		root:ALLtimesafterUPend_qn_Q75[i] = ALLtimesafterUPend_quantnorm[%Q75]
		
		WAVE ALLtimesafterUPend_quant = $""
		WAVE ALLtimesafterUPend_quantnorm = $""

		StatsQuantiles/Q TRIGtimesafterUPend
		duplicate/O W_statsquantiles TRIGtimesafterUPend_quant, TRIGtimesafterUPend_quantnorm
		WAVE TRIGtimesafterUPend_quant, TRIGtimesafterUPend_quantnorm
		TRIGtimesafterUPend_quantnorm /= medianfornormalization
		root:TRIGtimesafterUPend_qn_median[i] = TRIGtimesafterUPend_quantnorm[%Median]
		root:TRIGtimesafterUPend_qn_Q25[i] = TRIGtimesafterUPend_quantnorm[%Q25]
		root:TRIGtimesafterUPend_qn_Q75[i] = TRIGtimesafterUPend_quantnorm[%Q75]
		
		WAVE TRIGtimesafterUPend_quant = $""
		WAVE TRIGtimesafterUPend_quantnorm = $""

		killwaves W_StatsQuantiles

		// while we're in the folder, make normalized distributions of all the waves instead of just the quantiles
		// also make full histograms
		duplicate/O UPintervals UPintervals_norm
		WAVE UPintervals_norm
		UPintervals_norm /= medianfornormalization
		make/O/n=30 UPintervals_normhist
		histogram/B={0,0.01,600} UPintervals_norm UPintervals_normhist

		duplicate/O UPendtotrigUP UPendtotrigUP_norm
		WAVE UPendtotrigUP_norm
		UPendtotrigUP_norm /= medianfornormalization
		make/O/n=30 UPendtotrigUP_normhist
		histogram/B={0,0.01,600} UPendtotrigUP_norm UPendtotrigUP_normhist
		
		duplicate/O ALLtimesafterUPend ALLtimesafterUPend_norm
		WAVE ALLtimesafterUPend_norm
		ALLtimesafterUPend_norm /= medianfornormalization
		make/O/n=30 ALLtimesafterUPend_normhist
		histogram/B={0,0.01,600} ALLtimesafterUPend_norm ALLtimesafterUPend_normhist
		
		duplicate/O TRIGtimesafterUPend TRIGtimesafterUPend_norm
		WAVE TRIGtimesafterUPend_norm
		TRIGtimesafterUPend_norm /= medianfornormalization
		make/O/n=30 TRIGtimesafterUPend_normhist
		histogram/B={0,0.01,600} TRIGtimesafterUPend_norm TRIGtimesafterUPend_normhist
		
		WAVE UPintervals_norm = $""
		WAVE UPendtotrigUP_norm = $""
		WAVE ALLtimesafterUPend_norm = $""
		WAVE TRIGtimesafterUPend_norm = $""

	endfor
	
	setdatafolder root:
	
end

// trying to answer the question of whether what I've got is the same as the average difference
// add up all the differences of the UPendtotrigUPmedian from 1
function mylittletest (listwave)
	wave listwave
	
	setdatafolder root:
	variable numpoints = numpnts(listwave),i
	string nextfolder

	Variable theanswer = 0
			
	for (i=0; i < numpoints; i += 1)

		setdatafolder root:
		setdatafolder $(num2str(listwave[i]))
			
		WAVE UPendtotrigUP_quantnorm
		theanswer += (1 - UPendtotrigUP_quantnorm[%Median])
			
	endfor
	theanswer /= 16
	setdatafolder root:
	print theanswer
end


// OK here is the problem
// UPintervals contains all the UPendtotrigUP, which is probably reducing my significance values
// ALL times after UP end contains all TRIGtimesafterUPend, which is probably reducing my significance values

// so I need to go through UPendtotrigUP and TRIGtimesafterUPend and remove a point from UPintervals and ALLtimesafterUPend

function fixdistributions (listwave)
	WAVE listwave
	
	setdatafolder root:
	variable numpoints = numpnts(listwave),i,j
	string nextfolder

	Variable theanswer = 0
	Variable numUPendtotrigUP, numTRIGtimesafterUPend,  foundinUPintervals = 0, foundinALLtimesafterUPend = 0

	// in each data folder		
	for (i=0; i < numpoints; i += 1)

		setdatafolder root:
		setdatafolder $(num2str(listwave[i]))
		
		foundinUPintervals = 0
		foundinALLtimesafterUPend = 0
		
		WAVE UPintervals, UPendtotrigUP
		duplicate/O UPintervals, UPintervals_fixed	
		WAVE UPintervals_fixed
		
		numUPendtotrigUP = numpnts(UPendtotrigUP)
	
		for (j=0; j < numUPendtotrigUP; j += 1)
			
			findvalue/V=(UPendtotrigUP[j])/T=1 UPintervals_fixed
			// value found
			if (V_value != -1)
				UPintervals_fixed[V_Value] = Nan
				foundinUPintervals += 1
			endif	
	
		endfor
		removenans (UPintervals_fixed)
		printf "found %d matches in UPintervals\r", foundinUPintervals	

		//abort
		WAVE ALLtimesafterUPend, TRIGtimesafterUPend
		duplicate/o ALLtimesafterUPend, ALLtimesafterUPend_fixed
		WAVE ALLtimesafterUPend_fixed
		
		
		numTRIGtimesafterUPend = numpnts(TRIGtimesafterUPend)
		for (j=0; j < numTRIGtimesafterUPend; j += 1)
			
			findvalue/V=(TRIGtimesafterUPend[j])/T=1 ALLtimesafterUPend_fixed
			// value found
			if (V_value != -1)
				ALLtimesafterUPend_fixed[V_value] = Nan
				foundinALLtimesafterUPend += 1
			endif	
	
		endfor
		removenans (ALLtimesafterUPend_fixed)

		printf "found %d matches in ALLtimesafterUPend\r", foundinALLtimesafterUPend	
			
		WAVE UPintervals_fixed = $""
		WAVE ALLtimesafterUPend_fixed = $""
						
	endfor
			
	setdatafolder root:	

end


Function batchKStest (listwave)
	wave listwave
	
	setdatafolder root:
	variable numpoints = numpnts(listwave),i
	make/n=(numpoints) D_UPendtotrigUP, crit_UPendtotrigUP
	make/n=(numpoints) D_ALLtimesafterUPend, crit_ALLtimesafterUPend
	
	WAVE D_UPendtotrigUP, crit_UPendtotrgiUP, D_ALLtimesafterUPend, crit_ALLtimesafterUPend
	
	Variable theanswer = 0
	
	// in each data folder		
	for (i=0; i < numpoints; i += 1)

		setdatafolder root:
		setdatafolder $(num2str(listwave[i]))

		WAVE UPintervals_fixed, UPendtotrigUP
		WAVE ALLtimesafterUPend_fixed, TRIGtimesafterUPend

		statsKStest UPintervals_fixed, UPendtotrigUP
		WAVE W_KSResults
		D_UPendtotrigUP[i] = W_KSResults[3]
		crit_UPendtotrigUP[i] = W_KSResults[4]

		statsKStest ALLtimesafterUPend_fixed, TRIGtimesafterUPend
		WAVE W_KSResults
		D_ALLtimesafterUPend[i] = W_KSResults[3]
		crit_ALLtimesafterUPend[i] = W_KSResults[4]

	endfor

	setdatafolder root:

end


function makenewnormsandgiantwaves (listwave)
	wave listwave
	
	setdatafolder root:
	make/n=0/O UPintervals_fixedALL, UPendtotrigUPALL, ALLtimesafterUPend_fixedALL, TRIGtimesafterUPendALL	
	WAVE UPintervals_fixedALL, UPendtotrigUPALL, ALLtimesafterUPend_fixedALL, TRIGtimesafterUPendALL
	
	variable numpoints = numpnts(listwave),i
	variable medianfornormalization
	
	string nextfolder
			
	for (i=0; i < numpoints; i += 1)

		setdatafolder root:
		setdatafolder $(num2str(listwave[i]))
		
		WAVE UPintervals_fixed
		medianfornormalization = median(UPintervals_fixed, -inf,inf)
		
		// make normalized distributions of all the waves instead of just the quantiles
		// also make full histograms
		duplicate/O UPintervals_fixed UPintervalsfixed_norm
		WAVE UPintervalsfixed_norm
		UPintervalsfixed_norm /= medianfornormalization
		concatenate {UPintervalsfixed_norm}, UPintervals_fixedALL

		duplicate/O UPendtotrigUP UPendtotrigUP_norm
		WAVE UPendtotrigUP_norm
		UPendtotrigUP_norm /= medianfornormalization
		concatenate {UPendtotrigUP_norm}, UPendtotrigUPALL
		
		duplicate/O ALLtimesafterUPend_fixed ALLtimesafterUPendfixed_norm
		WAVE ALLtimesafterUPendfixed_norm
		ALLtimesafterUPendfixed_norm /= medianfornormalization
		concatenate {ALLtimesafterUPendfixed_norm}, ALLtimesafterUPend_fixedALL
		
		duplicate/O TRIGtimesafterUPend TRIGtimesafterUPend_norm
		WAVE TRIGtimesafterUPend_norm
		TRIGtimesafterUPend_norm /= medianfornormalization
		concatenate {TRIGtimesafterUPend_norm}, TRIGtimesafterUPendALL
		
		WAVE UPintervalsfixed_norm = $""
		WAVE UPendtotrigUP_norm = $""
		WAVE ALLtimesafterUPendfixed_norm = $""
		WAVE TRIGtimesafterUPend_norm = $""

	endfor
	
	setdatafolder root:
	
end