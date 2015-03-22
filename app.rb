require 'sinatra'
require 'pony'
require 'haml'
load 'cron.rb'

set :port, 8080
set :static, true
set :views, "views"



use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == 'admin' and password == 'admin'


	get '/' do
	    erb :form
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

	msg  = "Здпавейте, \n \nРазписанието за биенето на звънеца бе променено:\n\nПърва смяна:\n\n"
	msg += b.MailMsg(pbegin,p,pp) + "\nВтора смяна:\n\n"
	msg += b.MailMsg(vbegin,v,pv) + "\n"
	msg += "Това е автоматично генериран имейл, моля не отговаряйте."

	         
	    #erb :index, :locals => {'greeting' => greeting, 'name' => name, 'amount1' => amount1}

	    options = {
	    :to => '@gmail.com',
	    :from => '@gmail.com',
	    :subject => 'Звънец',
	    :body => msg,
	    #:html_body => (haml :test),
	    :via => :smtp,
	    :via_options => {
	      :address => 'smtp.gmail.com',
	      :port => 587,
	      :enable_starttls_auto => true,
	      :user_name => '',
	      :password => '',
	      :authentication => :plain,
	      :domain => 'HELO'
			    }
 	    }

  Pony.mail(options)

	
	end


end
