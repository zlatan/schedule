
class Bell
	@current=0
	def ModAdd (initial, shift)
	  #initial have format hour:minute example 5:12
	  #shift have format minute example 137
	  hourInitial = initial.split(":").first.to_i
	  minuteInitial = initial.split(":").last.to_i
	  result= "#{(hourInitial + ( minuteInitial + shift.to_i )/60 )}:#{(sprintf '%02d',  (minuteInitial + shift.to_i).modulo(60) )}"
	end 

	def CronFormatTime(time)
	   time.split(":").last+" "+time.split(":").first.to_i.to_s
	end
	
	def WriteCron(cron)
		begin
		  file = File.open("/home/kili/zvan", "w")
		  file.write(cron) 
		rescue IOError => e
		ensure
		  file.close unless file == nil
		end
	end
		
	def GenCron(pbegin, lesson, pause)
	  	all = "		*	*	*	"
		single = " ~/bell1.sh "
		double = " ~/bell.sh  "
		current=pbegin
		cron = CronFormatTime(ModAdd(pbegin,-5)) + all + single + "\n"
		cron += CronFormatTime(pbegin) + all + double + "\n"
		for i in 1..7 
		  current =  ModAdd(current,lesson[i])
		  cron += CronFormatTime(current) + all + single + "\n"
			if  pause[i] != nil then 
				if pause[i].to_i > 5 then 
			  current =  ModAdd(current,pause[i].to_i-5)
			  cron += CronFormatTime(current) + all + single + "\n"
		          current =  ModAdd(current,-(pause[i].to_i-5))
				end
			  current =  ModAdd(current,pause[i])
			  cron += CronFormatTime(current) + all + double + "\n"
			end
		end
	    return cron
	end
end

