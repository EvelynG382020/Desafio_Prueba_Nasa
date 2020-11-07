require "uri"
require "net/http"

def request(address, api_key)
    url = URI(address+ "&api_key=" +api_key)
    #debo concatenar la api key en la url
    
    http = Net::HTTP.new(url.host, url.port);
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    JSON.parse response.read_body #Json parse nos permite analizar una respuesta y para utilizarlo
    #es necesario requerirlo y en IRB se escribe require 'json'
end

    body = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY&page=1")
    body = body["photos"]

#crear un metodo llamado buid_web_page
def buid_web_page(response_hash)#que reciba en hash de respuesta
    #con todos los datos y construya una pagina web
    #se evalúa la pagina creada y tiene que tener formato

    html = "<html>\n<title>Api Nasa</title>\n<head>\n</head>\n<body>\n<h2>Api Nasa</h2>\n<ul>\n"
    response_hash.map {|img| html += "\t<li><img src=\"#{img["img_src"]}\"></li>\n"}
    html += "</ul>\n</body>\n</html>"
    File.write('nasa_api.html', html)
end

buid_web_page(response_hash)
puts "Pagina Web"

#pregunta bonus, crear metodo 
def photos_count(hash)#que reciba un hash de respuesta
    #devuelva new_hash #con el nombre de la camara y cantidad de fotos

    data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY&page=1")[0..25]#limitamos los restultados a 25
    photos = data.map{|x| x['url']}
    html = ""
    photos.each do |photo|
    html += "<img src=\"#{photo}\">\n"
    end
end

