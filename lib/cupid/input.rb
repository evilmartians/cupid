class Cupid
  module Input
    extend self

    TAG_NAMES = {
      :version_info       => 'VersionInfoRequestMsg',
      :get_system_status  => 'SystemStatusRequestMsg',
      :retrieve           => 'RetrieveRequestMsg'
    }

    def for(action)
      [TAG_NAMES.fetch(action), :xmlns => Cupid::NAMESPACE]
    end
  end
end
