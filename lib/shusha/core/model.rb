class ActiveRecord::Base
  def draw
    #just for indexing
  end

  private
  def context
    Shusha.context
  end

  def window
    context['shusha/windows_manager'].current_window
  end
end