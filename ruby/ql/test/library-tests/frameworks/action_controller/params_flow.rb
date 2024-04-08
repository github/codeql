class MyController < ActionController::Base
  def m1
    sink params[:a] # $hasTaintFlow
  end

  def m2
    sink params.as_json # $hasTaintFlow
  end

  def m2
    sink params.not_a_method
  end

  def m3
    sink params.permit(:some_key) # $hasTaintFlow
  end

  def m4
    sink params.require(:some_key) # $hasTaintFlow
  end

  def m5
    sink params.required(:some_key) # $hasTaintFlow
  end

  def m6
    sink params.deep_dup # $hasTaintFlow
  end

  def m7
    sink params.deep_transform_keys(&:upcase) # $hasTaintFlow
  end

  def m8
    sink params.deep_transform_keys!(&:upcase) # $hasTaintFlow
  end

  def m9
    sink params.delete_if { |v| v.match? regex } # $hasTaintFlow
  end

  def m10
    sink params.extract!(:a, :b) # $hasTaintFlow
  end

  def m11
    sink params.keep_if { |v| v.match? regex } # $hasTaintFlow
  end

  def m12
    sink params.select { |v| v.match? regex } # $hasTaintFlow
  end

  def m13
    sink params.select! { |v| v.match? regex } # $hasTaintFlow
  end

  def m14
    sink params.reject { |v| v.match? regex } # $hasTaintFlow
  end

  def m15
    sink params.reject! { |v| v.match? regex } # $hasTaintFlow
  end

  def m16
    sink params.to_h # $hasTaintFlow
  end

  def m17
    sink params.to_hash # $hasTaintFlow
  end

  def m18
    sink params.to_query # $hasTaintFlow
  end

  def m19
    sink params.to_param # $hasTaintFlow
  end

  def m20
    sink params.to_unsafe_h # $hasTaintFlow
  end

  def m21
    sink params.to_unsafe_hash # $hasTaintFlow
  end

  def m22
    sink params.transform_keys(&:upcase) # $hasTaintFlow
  end

  def m23
    sink params.transform_keys!(&:upcase) # $hasTaintFlow
  end

  def m24
    sink params.transform_values(&:upcase) # $hasTaintFlow
  end

  def m25
    sink params.transform_values!(&:upcase) # $hasTaintFlow
  end

  def m26
    sink params.values_at(:a, :b) # $hasTaintFlow
  end

  def m27
    sink params.merge({a: 1}) # $hasTaintFlow
    sink {a: 1}.merge(params) # $hasTaintFlow
  end

  def m28
    sink params.reverse_merge({a: 1}) # $hasTaintFlow
    sink {a: 1}.reverse_merge(params) # $hasTaintFlow
  end

  def m29
    sink params.with_defaults({a: 1, b: 2}) # $hasTaintFlow
    sink {a: 1}.with_defaults(params) # $hasTaintFlow
  end

  def m30
    sink params.merge!({a: 1}) # $hasTaintFlow
    sink {a: 1}.merge!(params) # $hasTaintFlow

    p = {a: 1}
    p.merge!(params)
    sink p # $hasTaintFlow
  end

  def m31
    sink params.reverse_merge!({a: 1}) # $hasTaintFlow
    sink {a: 1}.reverse_merge!(params) # $hasTaintFlow

    p = {a: 1}
    p.reverse_merge!(params)
    sink p # $hasTaintFlow
  end

  def m32
    sink params.with_defaults!({a: 1, b: 2}) # $hasTaintFlow
    sink {a: 1}.with_defaults!(params) # $hasTaintFlow

    p = {a: 1}
    p.with_defaults!(params)
    sink p # $hasTaintFlow
  end

  def m33
    sink params.reverse_update({a: 1, b: 2}) # $hasTaintFlow
    sink {a: 1}.reverse_update(params) # $hasTaintFlow

    p = {a: 1}
    p.reverse_update(params)
    sink p # $hasTaintFlow
  end
  
  include Mixin
end

module Mixin
  def m34
    sink params[:x] # $hasTaintFlow
  end
end

class Subclass < MyController
  def m35
    sink params[:x] # $hasTaintFlow
  end

  rescue_from 'Foo::Bar' do |err|
    sink params[:x] # $hasTaintFlow
  end
end

class UploadedFileTests < MyController
  def m36
    sink params[:file].original_filename # $hasTaintFlow
  end

  def m37
    sink params.require(:file).content_type # $hasTaintFlow
  end

  def m38
    sink params.permit(:file)[:file].headers # $hasTaintFlow
  end

  def m39
    sink params[:a].to_unsafe_h[:b][:file].read # $hasTaintFlow
  end

  def m40(a)
    params[:file].read(nil,a)
    sink a # $ hasTaintFlow
  end

  def m41
    a = ""
    params[:file].read(nil,a)
    sink a # $ hasTaintFlow
  end
end