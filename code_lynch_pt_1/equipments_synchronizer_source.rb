# 142 LoC Totally
module ExternalIntegration
  class EquipmentSynchronizer
    def initialize(account);end

    def call
      response = select_equipments_from_remote_api

      if response.success?
        parse_response_body(response.body)
        synchronization.success! unless synchronization.failure?
      else
        synchronization.failure!
      end
    rescue StandardError => e
      Rollbar.error(e)
      synchronization.failure!
    end
    handle_asynchronously :call

    private

    attr_reader :account, :synchronization

    def external_client
      @external_client ||= ExternalIntegration::Client.new(account)
    end

    def logger
      @logger ||= Logger.new('log/external_requests.log')
    end

    def parse_response_body(response_body)
      response_body.equipments.each do |json_equipment|
        next if account.equipments.exists?(serial_number: json_equipment[:serial_id])

        begin
          equipment_params = build_equipment_params(json_equipment)
          equipment = account.equipments.new(equipment_params)

          if equipment.save
            # some business logic
          else
            # some business logic
          end
        end
      end
    end

    def build_equipment_params(json_equipment)
      # 20 lines of method code   
      # calls build_company_from_params and  build_equipment_comment methods
      {}
    end

    def build_company_from_params(client_inn, client_name)
      # 24 LoC
    end

    def build_equipment_comment(json_equipment)
      # 15 LoC
    end
  end
end
