class TelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || :tel) unless /\A[0-9]{10,11}\z/ === value.gsub('-', '')
  end
end
