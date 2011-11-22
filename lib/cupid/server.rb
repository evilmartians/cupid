class Cupid
  class Server
    INPUT_NAMES = {
      :version_info       => 'VersionInfoRequestMsg',
      :get_system_status  => 'SystemStatusRequestMsg',
      :retrieve           => 'RetrieveRequestMsg',
      :create             => 'CreateRequest',
      :delete             => 'DeleteRequest'
    }

    attr_reader :account

    def initialize(account)
      @account = account
    end

    def input(action)
      [INPUT_NAMES.fetch(action), { :xmlns => Cupid::NAMESPACE }]
    end

    def filter(field, operator, value)
      {
        :filter => {
          :property => field,
          :simple_operator => operator,
          :value => value
        },
        :attributes! => {
          :filter => { 'xsi:type' => 'SimpleFilterPart' }
        }
      }
    end

    def object(type, options)
      {
        :objects => {
          :client => { 'ID' => account }
        }.merge(options),
        :attributes! => {
          :objects => { 'xsi:type' => type.to_s.camelcase }
        }
      }
    end

    def emails(ids)
      # TODO: REFACTOR ME
      {
        :objects => ids.map {|it|
          {
            :client => { 'ID' => account },
            'ID' => it
          }
        },
        :attributes! => {
          :objects => { 'xsi:type' => 'Email' }
        }
      }
    end
  end
end
