get '/login' do
  haml :login
end

post '/login' do
  user=login(params[:username],params[:password])
  if user
    session["user"]=user
  end
  user.to_json
end

get '/logout' do
  session["user"]=nil
end

post '/signup' do
  signup(params['email'],params['password'],params['repassword'])
end

get '/profile' do
  data= query_view(:users,:crud,:by_email,{"key"=>"\"#{session["user"]["email"]}\""})["rows"][0]["value"]
  data.delete "_id"
  data.delete "_rev"
  data.to_json
end

get '/:user/profile' do
  if session["user"]["username"]==params[:user]
    query_view(:users,:crud,:by_email,{key=>session["user"]["email"]})
  end
end

put '/:user/profile' do
  if session["user"]["username"]==params[:user]
    user={"name"=> params['user']['name'],
      "last_name"=> params['user']['lastname'],
      "email"=> params['user']['email'],
      "city" => params['user']['city'],
      "country"=> params['user']['country'],
      "legal_id"=> params['user']['legal_id']||nil,
      "landline_phone"=> params['user']['landline_phone']||nil,
      "mobile_phone"=> params['user']['mobile_phone']||nil,
      "street_address"=> params['user']['street_address']||nil,
      "latlng"=> params['user']['latlng']||nil,
      "google_base_subaccount"=> params['user']['google_base_subaccount']||nil}
    post_db(:users,user.to_json)
  end
end

post '/:user/profile' do
  if session["user"]["username"]==params[:user]
  end
end

def update_user
  {
    "name"=> params['user']['name'],
    "last_name"=> params['user']['last_name'],
    "legal_id"=> params['user']['legal_id'],
    "landline_phone"=> params['user']['landline_phone']||nil,
    "mobile_phone"=> params['user']['mobile_phone']||nil,
    "email"=> params['user']['email'],
    "street_address"=> params['user']['street_address'],
    "latlng"=> params['user']['latlng'],
    "google_base_subaccount"=> params['user']['google_base_subaccount']||nil
  }
end
