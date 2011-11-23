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

    def objects(type, objects)
      {
        :objects => objects.map {|object|
          {
            :client => { 'ID' => account },
          }.merge(object)
        },
        :attributes! => {
          :objects => { 'xsi:type' => type }
        }
      }
    end

    def object(type, options)
      objects type, [options]
    end

    def emails(ids)
      objects 'Email', ids.map {|it| { 'ID' => it }}
    end
  end
end
