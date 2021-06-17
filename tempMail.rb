require 'httparty'
require 'faraday'

class TempMail
    def initialize
            @email = ""
            @token = ""
            @messages = []
        end

    def generateEmail
        begin
            generateEmailUri = 'https://api.internal.temp-mail.io/api/v3/email/new'
            data = {"min_name_length" => 10, "max_name_length" => 10}
            new = HTTParty.post(generateEmailUri, :body => data)
            @email = new['email']
            @token = new['token']
        rescue => exception
            return exception
        end
    end
        
    def acessEmail
        begin
            acessEmailUri = "https://api.internal.temp-mail.io/api/v3/email/#{@email}/messages"
            return HTTParty.get(acessEmailUri)
        rescue => exception
            return exception
        end
    end

    def deleteEmail
        begin
            deleteEmailUri = "https://api.internal.temp-mail.io/api/v3/email/#{@email}"
            conn = Faraday.new
            body = { "token" => "#{@token}" }.to_json
            headers = { "content-type" => "application/json; charset=UTF-8"}
            return conn.run_request(:delete, deleteEmailUri, body, headers).status
        rescue => exception
            return exception
        end
    end

    def inputBoxEmail
        puts "\n\n"
        puts "Your email: #{@email} \nYour session token: #{@token}*\n\n"
        puts "Use the email above to receive an email."
        puts "You will receive an email as soon as you arrive\n in the inbox from #{@email}. Please wait!\n\n"
        puts "↓↓↓↓ YOUR EMAIL APPEARS BELOW!! ↓↓↓↓↓\n\n"
        while true
            if acessEmail.body.length > 3
                @messages << acessEmail.body
                @messages.each{ | v | v}
                deleteEmail
                return @messages
            end
        end
    end
end

module TEMPmail
    class TempMailGateway
        attr_accessor :tempMail

        def initialize(tempMail)
            @generateEmail = tempMail.generateEmail
            @acessEmail = tempMail.acessEmail
            @inputBoxEmail = tempMail.inputBoxEmail
        end

        def execute
            @generateEmail
            @acessEmail
            return @inputBoxEmail
        end
    end

    tempMail = TempMail.new
    handle = TempMailGateway.new(tempMail)
end




