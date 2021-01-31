require 'json'
require 'net/http'

def request(address, api_key)
    url = URI(address+api_key)
    #debo concatenar la api key en la url
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    JSON.parse response.read_body #Json parse nos permite analizar una respuesta y para utilizarlo
    #es necesario requerirlo y en IRB se escribe require 'json'
end

#crear un metodo llamado build_web_page
def build_web_page(hash)#que reciba en hash de respuesta
    #con todos los datos y construya una pagina web
    #se evalúa la pagina creada y tiene que tener formato
    photos = hash["photos"]

    html = "<html>\n<title>Fotos Api Nasa</title>\n<head>\n</head>\n<body>\n<h2>Fotos Api Nasa</h2>\n<ul>\n"
    photos.map {|img| html += "\t<li><img src=#{img["img_src"]}></li>\n"}
    html += "</ul>\n</body>\n</html>"
    File.write('nasa_api.html', html)
end

def photos_count(data)
    photos_array = data["photos"]#accediendo al arrelgo fotos
    final_array = []
   
    photos_array.each do |i|# voy a iterar para guardarlos en el arreglo final nombre y camara
        final_array.push i['camera']['name']

    end

    final_hash = final_array.group_by {|x| x}#esta agrupando todos los nombres
    final_hash.each do |k,v|# y mi archivo final será un hash con nombre y camara
        final_hash[k] = v.count
    end

    final_hash #devuelve el hash final del método
end

    dirección_api = ("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key="
    key_api = "ZweOQ9fc4zm3OJEZ918gT7pct9HaIaRS2AP6rrUb&page=1"
    
    data = request(dirección_api, key_api)
        
    build_web_page(data)#llamo al metódo de la pagina web y le paso la url que tengo en mi variable data
    print photos_count(data)#llamo al método que filtra las fotos por nombre y camara y le paso la variable data donde está la url
