require 'sinatra'
load 'cron.rb'

set :port, 8080
set :static, true
set :views, "views"

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'admin' and password == 'admin'


	get '/' do
	    erb :form2
	end

	post '/' do
		p = Array.new(7)
		v = Array.new(7)
		pp = Array.new(7)
		pv = Array.new(7)
		data = params[:data]
	        pbegin= params[:pbegin]
	        vbegin= params[:vbegin]

	for i in 1..7
	    	p["#{i}".to_i] = params[:"p#{i}"]
		v["#{i}".to_i] = params[:"v#{i}"]
		if i > 6 then 	
			next
		   end
	    	pp["#{i}".to_i] = params[:"pp#{i}"]
		pv["#{i}".to_i] = params[:"pv#{i}"]
	    end
	
	b = Bell.new
	cron  = b.GenCron(pbegin,p,pp)
        cron += b.GenCron(vbegin,v,pv)
	b.WriteCron(cron)

	    #erb :index, :locals => {'greeting' => greeting, 'name' => name, 'amount1' => amount1}

	
		
	end


end

get '/log' do
	    erb :form
	end

