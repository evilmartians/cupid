class Cupid
  module Create
    def create(type, data)
      resource :create, server.object(type, data)
    end

    def create_folder(title, parent, options={})
      create 'DataFolder', folder(title, parent, options)
    end

    def create_email(title, body, options={})
      create 'Email', email(title, body, options)
    end

    def create_delivery(email, list)
      create 'Send', delivery(email, list)
    end

    def create_path(*folder_names)
      children = folders.select(&:root?)
      folder_names.inject(nil) do |parent, name|
        folder = children.find {|it| it.name == name }
        children = folder ? folder.children : []
        folder or create_folder(name, parent)
      end
    end

    private

    def folder(title, parent, options)
      raise ArgumentError unless title and parent and options

      {
        :name           => title,
        :content_type   => :email,
        :description    => nil,
        :is_active      => true,
        :is_editable    => true,
        :allow_children => true,
        :parent_folder  => {
          'ID' => parent
        }
      }.merge options
    end

    def email(title, body, options)
      raise ArgumentError unless title and body and options

      {
        :email_type    => 'HTML',
        :character_set => 'utf-8',
        :subject       => title,
        'HTMLBody'     => body,
        'IsHTMLPaste'  => true
      }.merge options
    end

    def delivery(email, list)
      raise ArgumentError unless email and list

      {
        :email => { 'ID' => email },
        :list  => { 'ID' => list }
      }
    end
  end
end
