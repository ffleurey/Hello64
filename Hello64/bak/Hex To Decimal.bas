10 print "{clear}":y=1:d=0:print"please enter hex number":input h$
20 l=len(h$):for n=0 to l-1
40 gosub 200:next
50 print "denary number is ";d
100 end
200 p$=mid$(h$,l-n,1):a=asc(p$)
210 if a<48 or a >70 then gosub 300:goto270
220 if a<65 and a >57 then gosub 300:goto270
230 if a<=57 then q=a-48
240 if a >=65 then q=a-55
250 if a >=97 then q=a-87
260 d=d+q*y:y=y*16
270 return
300 print "bad hex...please try again":end
310 for n=1 to 1000:next:return
