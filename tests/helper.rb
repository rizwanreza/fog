require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog', 'bin'))

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

def has_error(error, &block)
  begin
    yield
    @formatador.display_line("[red]did not raise #{error}[/]")
    false
  rescue error
    true
  end
end

def has_format(original_data, original_format, original = true)
  valid = true
  data = original_data.dup
  format = original_format.dup
  for key, value in format
    valid &&= data.has_key?(key)
    datum = data.delete(key)
    format.delete(key)
    case value
    when Array
      valid &&= datum.is_a?(Array)
      for element in datum
        type = value.first
        if type.is_a?(Hash)
          valid &&= has_format({:element => element}, {:element => type}, false)
        else
          valid &&= element.is_a?(type)
        end
      end
    when Hash
      valid &&= datum.is_a?(Hash)
      valid &&= has_format(datum, value, false)
    else
      valid &&= datum.is_a?(value)
    end
  end
  valid &&= data.empty? && format.empty?
  if !valid && original
    @formatador.display_line("[red]#{original_data.inspect} does not match #{original_format.inspect}[/]")
  end
  valid
end
