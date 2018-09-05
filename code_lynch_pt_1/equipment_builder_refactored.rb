module ExternalSyncronization
  module Events
    class EquipmentBuilder
      include SyncronizationMethods
      
      def initialize(account, params); end

      def call
        response = select_equipments_from_external_api
        create_equipment(response.body) if response.success?
      end

      private

      attr_reader :account, :synchronization, :params

      def parse_response_body(response_body)
        json_equipment = response_body.equipments.select { |e| e[:serial_id] == params[:serial_id] }.first
        equipment_params = EquipmentParamsBuilder.new(json_equipment).call
        equipment = account.equipments.create(equipment_params)
      end
  end
end
