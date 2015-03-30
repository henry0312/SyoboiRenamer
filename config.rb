USER = "henry"
TEMPLATE = "$Title$/[$StTime$][$ChName$] $Title$ \#$Count$ $SubTitle$.m2ts"
CHANNEL = JSON.load(File.read(File.dirname(File.expand_path(__FILE__)) + "/channel.json"))
REPLACE = JSON.load(File.read(File.dirname(File.expand_path(__FILE__)) + "/replace.json"))
