class Cupid
  class Server
    INPUT_NAMES = {
      :version_info       => 'VersionInfoRequestMsg',
      :get_system_status  => 'SystemStatusRequestMsg',
      :retrieve           => 'RetrieveRequestMsg',
      :schedule           => 'ScheduleRequestMsg',
      :create             => 'CreateRequest',
      :delete             => 'DeleteRequest',
      :update             => 'UpdateRequest',
      :describe           => 'DefinitionRequestMsg',
      :perform            => "PerformRequestMsg"
    }

    attr_reader :account

    def initialize(account)
      @account = account
    end

    def input(action)
      [INPUT_NAMES.fetch(action), { :xmlns => Cupid::NAMESPACE }]
    end

    def filter(field, operator, value)
      return {} unless value
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

    def folders(ids)
      objects 'DataFolder', ids.map {|it| { 'ID' => it }}
    end

    def send_objects(ids)
      objects "Send", ids.collect{ |id| {"ID" => id} }
    end
  end
end
