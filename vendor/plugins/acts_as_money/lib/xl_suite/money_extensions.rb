module XlSuite
  module MoneyExtensions
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :extend, ClassMethods
    end

    module InstanceMethods
      def zero?
        self.cents.zero?
      end

      def to_f
        self.cents / 100.0
      end

      def floor
        self.class.new(self.cents.floor, self.currency)
      end

      def ceil
        self.class.new(self.cents.ceil, self.currency)
      end

      def round
        self.class.new(self.cents.round, self.currency)
      end

      def abs
        self.class.new(self.cents.abs, self.currency)
      end

      def to_liquid
        format(:with_currency, :html)
      end
    end

    module ClassMethods
      def penny(currency=Money.default_currency)
        Money.new(1, currency)
      end

      def zero(currency=Money.default_currency)
        Money.new(0, currency)
      end
    end
  end
end
