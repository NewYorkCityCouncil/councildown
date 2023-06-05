library(fresh)

use_googlefont("Open Sans")

create_theme(theme = "default",
             bs_vars(body_bg = "#FFF",
                     "font-family-serif" = "Georgia"
             ),
             bs_vars_font(family_sans_serif = "Open Sans"
             ),
             bs_vars_navbar(default_bg = "#E6E6E6",
                            default_color = "#666666",
                            default_link_color = "#1D5FD6",
                            default_link_active_color = "#222222",
                            default_link_active_bg = "#CACACA",
                            inverse_link_color = "#1D5FD6",
                            inverse_link_active_color = "#222222",
                            inverse_link_active_bg = "#CACACA",
                            inverse_bg = "#E6E6E6",
                            inverse_color = "#666666",
             ),
             bs_vars_global(grid_columns = 12,
                            grid_gutter_width = "30px",
                            body_bg = "#FFF",
                            text_color = "#222222",
                            link_color = "#1D5FD6"
             ),
             bs_vars_color(brand_primary = "#CACACA",
                           brand_success = "#2F56A6",
                           brand_info = "#222222",
                           brand_warning = "#B63F26",
                           brand_danger = "#B63F26"
             ),
             bs_vars_wells(bg = "#FFFFFF"),
             bs_vars_tabs(border_color = "#666666",
                          active_link_hover_bg = "#FFF"
             ),
             output_file = file.path("assets/council-theme.css")
)

