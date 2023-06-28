module Shopify
  module Pagination
    module Helper
      def cursor_paginate_polaris(items, options = {})
        return if items.blank?

        return unless items.respond_to?(:cursor_pagination)

        additional_params = options.with_indifferent_access[:params] || {}
        additional_params[:only_path] = false

        if items.cursor_pagination[:previous] || items.cursor_pagination[:next]
          previous_button_url = url_for(
            additional_params.merge(
              page_info: items.cursor_pagination.dig(:previous, :page_info),
              direction: 'previous',
              limit: items.cursor_pagination.dig(:previous, :limit)
            )
          )
          previous_button_class = items.cursor_pagination[:previous].blank? && 'Polaris-Button--disabled'

          next_button_url = url_for(
            additional_params.merge(
              page_info: items.cursor_pagination.dig(:next, :page_info),
              direction: 'next',
              limit: items.cursor_pagination.dig(:next, :limit)
            )
          )
          next_button_class = items.cursor_pagination[:next].blank? && 'Polaris-Button--disabled'
        end

        %(<nav class="#{options[:pagination_class]} " aria-label="Pagination">
          <div data-buttongroup-segmented="true" class="Polaris-ButtonGroup Polaris-ButtonGroup--segmented">
            <div class="Polaris-ButtonGroup__Item">
              <a href="#{previous_button_url}" data-controller="polaris-button" class="Polaris-Button Polaris-Button--outline Polaris-Button--iconOnly #{previous_button_class}">
                <span class="Polaris-Button__Content">
                  <div class="Polaris-Button__Icon">
                    <span class="Polaris-Icon">
                      <svg viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true">
                        <path d="M12 16a.997.997 0 0 1-.707-.293l-5-5a.999.999 0 0 1 0-1.414l5-5a.999.999 0 1 1 1.414 1.414l-4.293 4.293 4.293 4.293a.999.999 0 0 1-.707 1.707z"></path>
                      </svg>
                    </span>
                  </div>
                </span>
              </a>
            </div>
            <div class="Polaris-ButtonGroup__Item">
              <a href="#{next_button_url}" data-controller="polaris-button" class="Polaris-Button Polaris-Button--outline Polaris-Button--iconOnly #{next_button_class}">
                <span class="Polaris-Button__Content">
                  <div class="Polaris-Button__Icon">
                    <span class="Polaris-Icon">
                      <svg viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" class="Polaris-Icon__Svg" focusable="false" aria-hidden="true">
                        <path d="M8 16a.999.999 0 0 1-.707-1.707l4.293-4.293-4.293-4.293a.999.999 0 1 1 1.414-1.414l5 5a.999.999 0 0 1 0 1.414l-5 5a.997.997 0 0 1-.707.293z"></path>
                      </svg>
                    </span>
                  </div>
                </span>
              </a>
            </div>
          </div>
        </nav>).html_safe if items.cursor_pagination[:previous] || items.cursor_pagination[:next]
      end

      def cursor_paginate(items, options = {})
        return if items.blank?

        return unless items.respond_to?(:cursor_pagination)

        res = ["<div class='pagination cursor-based #{options[:pagination_class]}'><span class='button-group'>"]

        additional_params = options.with_indifferent_access[:params] || {}
        additional_params[:only_path] = false

        if items.cursor_pagination[:previous] || items.cursor_pagination[:next]
          res << link_to(
            raw(I18n.t('views.pagination.previous')),
            url_for(
              additional_params.merge(
                page_info: items.cursor_pagination.dig(:previous, :page_info),
                direction: 'previous',
                limit: items.cursor_pagination.dig(:previous, :limit)
              )
            ),
            class: "button secondary btn btn-default icon-arrow-left #{items.cursor_pagination[:previous].blank? && 'disabled'}"
          )

          res << link_to(
            raw(I18n.t('views.pagination.next')),
            url_for(
              additional_params.merge(
                page_info: items.cursor_pagination.dig(:next, :page_info),
                direction: 'next',
                limit: items.cursor_pagination.dig(:next, :limit)
              )
            ),
            class: "button secondary btn btn-default icon-arrow-right #{items.cursor_pagination[:next].blank? && 'disabled'}"
          )
        end

        res << '</span></div>'

        raw res.join(' ')
      end
    end
  end
end
