# 142 LoC Totally
module ExternalIntegration
  class EquipmentSynchronizer
    include EquipmentSynchronizerMethods
    
    def initialize(account);end

    def call
      response = select_equipments_from_remote_api

      if response.success?
        create_equipments(response.body)
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

    def logger
      @logger ||= Logger.new('log/external_requests.log')
    end

    def create_equipments(response_body)
      response_body.equipments.each do |json_equipment|
        next if account.equipments.exists?(serial_number: json_equipment[:serial_id])

        begin
          equipment_params = EquipmentParamsBuilder.new(json_equipment).call
          equipment = account.equipments.new(equipment_params)

          if equipment.save
            # some business logic
          else
            # some business logic
          end
        end
      end
    end
  end
end
