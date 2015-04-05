USER = "henry"
TEMPLATE = "$Title$/[$StTime$][$ChName$] $Title$ \#$Count$ $SubTitle$"
CHANNEL = JSON.load(File.read(File.dirname(File.expand_path(__FILE__)) + "/channel.json"))
REPLACE = JSON.load(File.read(File.dirname(File.expand_path(__FILE__)) + "/replace.json"))
