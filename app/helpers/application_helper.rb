module ApplicationHelper
  def sortable(column, title = nil, cust_css_class = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.permit(:title, :participate_count, :created_at)
      .merge(:sort => column, :direction => direction, :page => nil), {
        :class => [css_class, "glyphicon", "glyphicon-sort", cust_css_class]}
  end
end
