<customfield-create xmlns:th="http://www.thymeleaf.org">
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <h1 th:text="${customField eq null} ? #{AddNewCustomField} : #{EditCustomField}">カスタムフィールド編集</h1>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <form id="custom-field-form" th:fragment="form(title,customfield)" class="form-horizontal" method="post" th:object="${form}" th:action="@{__$ADMIN_PATH__/customfields/create}">
                <div class="alert alert-danger" th:if="${#fields.hasErrors('all')}">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <span th:text="#{Error}">Error</span>
                </div>
                <input type="hidden" name="id" th:value="${customField}? ${customField.id} : ''"  />
                <div class="form-group" th:classappend="${#fields.hasErrors('name')}? has-error">
                    <label class="col-sm-2 control-label" th:text="#{FieldName}">FieldName</label>
                    <div class="col-sm-6">
                        <input type="text" th:field="*{name}" class="form-control" th:attr="placeholder=#{FieldName}" />
                        <span class="help-block" th:each="err : ${#fields.errors('name')}" th:text="${err}" />
                    </div>
                </div>
                <div class="form-group" th:classappend="${#fields.hasErrors('code')}? has-error">
                    <label class="col-sm-2 control-label" th:text="#{Code}">FieldName</label>
                    <div class="col-sm-6">
                        <input type="text" th:field="*{code}" class="form-control" th:attr="placeholder=#{Code}" />
                        <span class="help-block" th:each="err : ${#fields.errors('code')}" th:text="${err}" />
                    </div>
                </div>
                <div class="form-group" th:classappend="${#fields.hasErrors('description')}? has-error">
                    <label class="col-sm-2 control-label" th:text="#{Description}">Description</label>
                    <div class="col-sm-6">
                        <textarea type="text" th:field="*{description}" class="form-control" style="min-height: 150px" th:attr="placeholder=#{Description}"></textarea>
                        <span class="help-block" th:each="err : ${#fields.errors('description')}" th:text="${err}" />
                    </div>
                </div>
                <div class="form-group" th:classappend="${#fields.hasErrors('type')}? has-error">
                    <label class="col-sm-2 control-label" th:text="#{FieldType}">FieldType</label>
                    <div class="col-sm-6">
                        <select class="form-control" th:field="*{type}">
                            <option th:each="fieldType : ${fieldTypes}" th:value="${fieldType}" th:text="${#messages.msg('CustomField.FieldType.' + fieldType)}" th:selected="${customField ne null and #strings.toString(customField.fieldType) eq #strings.toString(fieldType)}">指定なし</option>
                        </select>
                        <span class="help-block" th:each="err : ${#fields.errors('type')}" th:text="${err}" />
                    </div>
                </div>
                <div id="custom-field-options" class="form-group field-option-group">
                    <label class="col-sm-2 control-label" th:text="#{FieldOption}">FieldOption</label>
                    <div class="col-sm-6">
                        <input type="text" id="custom-field-options-input" class="form-control"/>
                    </div>
                    <div class="col-sm-1">
                        <a href="#" class="btn btn-default" data-append="option"><span class="glyphicon glyphicon-plus"></span> <span th:text="#{Add}">追加</span></a>
                    </div>
                    <div class="col-sm-offset-2 col-sm-10">
                        <ul class="sortable">
                            <!--
                    <th:block th:if="${customField ne null}">
                    <li class="option col-sm-7" th:if="${#lists.size(customField.options) gt 0}" th:each="option : ${customField.options}">
                        <span class="grippy"></span>
                        <div class="field-option" th:attr="data-name=${option.name}" th:text="${option.name}"></div>
                        <button class="pull-right btn btn-link remove" data-dismiss="option"><span class="glyphicon glyphicon-remove"></span></button>
                    </li>
                    </th:block>
-->
                            <th:block th:if="*{options ne null}">
                                <li class="option col-sm-7" th:each="option : *{options}">
                                    <span class="grippy"></span>
                                    <div class="field-option" th:attr="data-name=${option}" th:text="${option}"></div>
                                    <button class="pull-right btn btn-link remove" data-dismiss="option"><span class="glyphicon glyphicon-remove"></span></button>
                                </li>
                            </th:block>
                            <script id="option-tmpl" type="text/x-jsrender">
                    <li class="option col-sm-7">
                        <span class="grippy"></span>
                        <div class="field-option"></div>
                        <button class="pull-right btn btn-link remove" data-dismiss="option"><span class="glyphicon glyphicon-remove"></span></button>
                    </li>
                    </script>
                        </ul>
                    </div>
                    <script>
                        $(function() {
                            $('.sortable').sortable();

                            var $customFieldForm = $('#custom-field-form');
                            var $fieldOption = $('#custom-field-options');
                            var $customInput = $('#custom-field-options-input');

                            $customFieldForm.on('change', 'select[name="type"]', function() {
                                var value = $(this).val().toString();
                                if (value == 'SELECTBOX' || value == 'CHECKBOX' || value == 'RADIO') {
                                    $fieldOption.show();
                                } else {
                                    $fieldOption.hide();
                                }
                            });
                            $('select[name="type"]',$customFieldForm).trigger('change');

                            $customInput.on('keypress', function(e) {
                                if (e.keyCode === 13) {
                                    e.preventDefault();
                                    $('[data-append="option"]').trigger('click');
                                }
                            });

                            var $options = [];
                            $fieldOption.on('click', '[data-append="option"]', function() {
                                var customInputOption = $customInput.val();

                                if (customInputOption == ''
                                        || isDuplicated($('.field-option'), customInputOption)) {
                                    $customInput.closest('.form-group').addClass('has-error');
                                    return false;
                                } else {
                                    $options.push(customInputOption);
                                    var tmpl = $.templates("#option-tmpl");
                                    var $content = $(tmpl.render());
                                    $('.field-option', $content).attr('data-name', customInputOption).text(customInputOption);
                                    $('.sortable').append($content);
                                    $customInput.val('').focus().closest('.form-group').removeClass('has-error');
                                }
                                return false;
                            });

                            var isDuplicated = function ($optionClass, target) {
                                var duplicate = false;
                                $.each($optionClass, function() {
                                    var option = $(this).data('name');
                                    if (option == target) {
                                        duplicate = true;
                                    }
                                });
                                return duplicate;
                            };

                            $('.field-option-group').on('click', '[data-dismiss="option"]', function() {
                                $(this).closest('.option').remove();
                                return false;
                            });

                            $customFieldForm.on('submit', function() {
                                $('.field-option').each(function(index) {
                                    var option = $(this).data('name');
                                    var postName = "options[" + index + "]";
                                    var field = $('<input type="hidden" />').attr("name", postName).val(option);
                                    $customFieldForm.append(field);
                                });
                            });
                        });
                    </script>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <div class="btn-group">
                            <button name="submit" class="btn btn-primary ok" th:text="#{Save}">Save</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</customfield-create>
