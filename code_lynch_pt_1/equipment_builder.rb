module ExternalSyncronization
  module Events
    class EquipmentBuilder
      def initialize(account, params); end

      def call
        response = select_equipments_from_external_api
        parse_response_body(response.body) if response.success?
      end

      private

      attr_reader :account, :synchronization, :params

      def external_client
        @external_client ||= External::Client.new(account)
      end

      def select_equipments_from_external_api
        # 10 LoC
      end

      def parse_response_body(response_body)
        json_equipment = response_body.equipments.select { |e| e[:serial_id] == params[:serial_id] }.first
        equipment_params = build_equipment_params(json_equipment)
        equipment = account.equipments.create(equipment_params)
      end

      def build_equipment_params(json_equipment)
        # 24 LoC
        # calls build_company_from_params and build_equipment_comment methods
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
