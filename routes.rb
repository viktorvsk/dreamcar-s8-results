# frozen_string_literal: true

put '/' do
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
    redirect 'http://audi_s8.recar.io/admin'
  else
    'ERROR'
  end
end
