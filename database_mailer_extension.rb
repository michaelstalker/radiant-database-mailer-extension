# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class DatabaseMailerExtension < Radiant::Extension
  version "1.0"
  description "Save fields from mailer forms to the database."
  url "http://github.com/ihoka/radiant-database-mailer-extension"
  
  define_routes do |map|
    map.connect 'admin/database_mailer/:action', :controller => 'admin/form_datas'
  end
  
  def activate
    require 'will_paginate'
    throw "MailerExtension must be loaded before DatabaseMailerExtension" unless defined?(MailerExtension)
    MailController.class_eval do
      include DatabaseMailerProcessing
      alias_method_chain :process_mail, :database
    end
    WillPaginate.enable_named_scope
    admin.tabs.add "Database Mailer", "/admin/database_mailer", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Database Mailer"
  end
  
end