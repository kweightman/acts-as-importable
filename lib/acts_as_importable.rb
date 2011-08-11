module Acts
  module Importable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def acts_as_importable(options = {})
        # Store the import target class with the legacy class
        write_inheritable_attribute :importable_to, options[:to]

        # Don't extend or include twice. This will allow acts_as_importable to be called multiple times.
        # eg. once in a parent class and once again in the child class, where it can override some options.
        extend  Acts::Importable::SingletonMethods unless self.methods.include?('import') && self.methods.include?('import_all')
        include Acts::Importable::InstanceMethods unless self.included_modules.include?(Acts::Importable::InstanceMethods)
      end

    end # ClassMethods

    module SingletonMethods
      def import(id)
        find(id).import
      end

      def import_all
        self.before_import if self.method_defined? :before_import
        new_models = all.collect do |legacy_model|
          legacy_model.import
        end
        self.after_import(new_models) if self.method_defined? :after_import
      end

      def import_all_in_batches
        self.before_import if self.method_defined? :before_import
        self.find_each do |legacy_model|
          legacy_model.import
        end
        self.after_import if self.method_defined? :after_import
      end

      def lookup_class
        read_inheritable_attribute(:importable_to) || "#{self.to_s.split('::').last}"
      end

      def lookup(id)
        lookups[id] ||= lookup_class.constantize.first(:conditions => {:legacy_id => id, :legacy_class => self.to_s}).try(:id)
      end

      def flush_lookups!
        @lookups = {}
      end

      private

      def lookups
        @lookups ||= {}
      end

    end # SingletonMethods

    module InstanceMethods

      def import
        before_import if self.class.instance_methods.include? :before_import
        to_model.tap do |new_model|
          if new_model
            new_model.legacy_id     = self.id         if new_model.respond_to?(:"legacy_id=")
            new_model.legacy_class  = self.class.to_s if new_model.respond_to?(:"legacy_class=")

            if !new_model.save(:validate => false)
              p new_model.errors
              # TODO log an error that the model failed to save
              # TODO remove the raise once we're out of the development cycle
              raise
            else
              after_import(new_model) if self.class.instance_methods.include? :after_import
            end
          end
        end
      end
    end # InstanceMethods

  end
end

require 'core_extensions'
ActiveRecord::Base.class_eval { include Acts::Importable }

