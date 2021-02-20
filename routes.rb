# frozen_string_literal: true

get '/' do
  accounts = REDIS.scan(0, match: "*#{params[:search]}*").last.sort

  if accounts.any?
    ids = REDIS.mget(*accounts)
    Hash[accounts.zip(ids)].to_json
  else
    [].to_json
  end
end

put '/update' do
  raise if params[:password].strip != ENV['PASSWORD'].strip
  raise unless params[:file]
  raise unless params[:file][:tempfile]

  accounts = CSV.parse(params[:file][:tempfile].read, col_sep: ';')
  accounts.map!(&:reverse)
  ids = accounts.map(&:last)

  raise if ids.uniq.count != ids.count

  accounts.flatten!

  result = REDIS.multi do |multi|
    multi.flushdb
    multi.mset(*accounts)
  end

  if result.first == 'OK'
    'OK'
  else
    'ERROR'
  end
end
