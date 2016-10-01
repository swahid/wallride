<page-tree xmlns:th="http://www.thymeleaf.org">
    <div>
        <div id="wr-page-header">
            <div class="page-header container-fluid">
                <div class="pull-left">
                    <h1 th:text="#{Pages}">Pages</h1>
                </div>
                <div class="pull-right">
                    <div class="btn-group">
                        <a th:href="@{__$ADMIN_PATH__/pages/tree(part=page-create-form,query=${query})}" data-toggle="modal" data-target="#page-create-modal" class="btn btn-sm btn-primary"><span class="glyphicon glyphicon-plus"></span> <span th:text="#{AddNewPage}">Add New</span></a>
                    </div>
                    <div class="btn-group">
                        <button id="update-page-sort" type="submit" class="btn btn-sm btn-primary" data-loading-text="saving..." disabled="true" th:if="!${#lists.isEmpty(pageNodes)}" th:text="#{SaveOrder}">Save Order</button>
                    </div>
                    <script th:inline="javascript">
                        $(function() {
                            $('#update-page-sort').click(function(e) {
                                e.preventDefault();
                                $(this).button('loading');
                                var data = $('#page-tree').nestedSortable('toArray', {startDepthCount: 0});
                                $.ajax({
                                    url: /*[[@{__$ADMIN_PATH__/pages.json}]]*/ '#',
                                    type: 'put',
                                    dataType: 'json',
                                    data: JSON.stringify(data),
                                    contentType: 'application/json',
                                    success: function() {
                                        location = /*[[@{__$ADMIN_PATH__/pages/tree?updated(query=${query})}]]*/ '#';
                                    },
                                    error: function() {
                                    }
                                });
                            });
                        });
                    </script>
                    <div class="btn-group">
                        <a th:attr="title=#{ListPage}" class="btn btn-default btn-sm" th:href="@{__$ADMIN_PATH__/pages/index(query=${query})}" style="padding:7px 12px;"><span class="glyphicon glyphicon-list"></span></a>
                        <a th:attr="title=#{TreePage}" title="ツリー表示" class="btn btn-default btn-sm active" style="height: 34px"><i class="flaticon-category"></i> </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="wr-page-content">
            <div class="container-fluid">
                <div class="alert alert-success" th:if="${savedPage ne null}">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <span th:text="#{SavedPage}">Page saved.</span>
                </div>
                <div class="alert alert-success" th:if="${deletedPage ne null}">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <span th:text="#{DeletedPage}">Page deleted.</span>
                </div>
                <ul th:unless="${#lists.isEmpty(pageNodes)}" th:replace="page/tree::page(${pageNodes})"></ul>
                <ul id="page-tree" class="nested-sortable" th:fragment="page(nodes)">
                    <li th:each="node : ${nodes}" th:id="${'page-tree_' + node.object.id}">
                        <div class="category clearfix" th:classappend="${#strings.toString(node.object.status) ne 'PUBLISHED'} ? 'off'">
                            <div class="wr-tree-options pull-left">
                                <span class="wr-tree-option disclose"><span class="glyphicon glyphicon-chevron-right"></span></span>
                                <span class="wr-tree-option title" th:text="${node.object.title}"></span>
                                <span class="wr-tree-option" th:if="${node.object.code}" th:text="${'/' + node.object.code}">/cate1</span>
                                <span class="wr-tree-option small" style="margin-left: 10px;" th:classappend="'wr-post-status-' + ${node.object.status}">● <span th:text="#{Post.Status. + ${node.object.status}}"></span></span>
                            </div>
                            <div class="wr-tree-options pull-right">
                                <button class="btn btn-link wr-tree-option" th:href="@{__$ADMIN_PATH__/pages/edit(id=${node.object.id},query=${query})}"><span class="glyphicon glyphicon-pencil"></span> <span th:text="#{Edit}">Edit</span></button>
                                <button class="btn btn-link wr-tree-option" th:href="@{__$ADMIN_PATH__/pages/tree(part=page-create-form,parentId=${node.object.id},query=${query})}" data-toggle="modal" data-target="#page-create-modal"><span class="glyphicon glyphicon-plus"></span> <span th:text="#{Add}">Add</span></button>
                                <button class="btn btn-link wr-tree-option" th:href="@{__$ADMIN_PATH__/pages/tree(part=page-delete-form,id=${node.object.id},query=${query})}" data-toggle="modal" data-target="#page-delete-modal"><span class="glyphicon glyphicon-remove"></span></button>
                            </div>
                            <script>
                                $(function() {
                                    $('#page-tree button[href]').not('[data-toggle]').click(function() {
                                        location = $(this).attr('href');
                                    });
                                });
                            </script>
                        </div>
                        <ul th:unless="${#lists.isEmpty(node.children)}" th:include="page/tree::page(${node.children})"></ul>
                    </li>
                </ul>
                <!-- #page-create-modal -->
                <div id="page-create-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div id="page-create-dialog" class="modal-dialog">
                        <form>
                            <div th:fragment="page-create-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" th:text="#{AddNewPage}">Add New Page</h4>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <select name="parentId" class="form-control">
                                            <option value="" th:text="#{SelectParentPage}">Select Parent Page</option>
                                            <option th:each="page : ${#pages.getAllPages(true)}" th:value="${page.id}" th:text="${page.title}" th:selected="${page.id eq parentId}"></option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <input type="text" name="title" class="form-control" th:attr="placeholder=#{Title}" />
                                    </div>
                                    <div class="form-group">
                                        <span th:text="${WEBSITE_LINK + '/page/'}">http://wallride.org/page/</span>
                                        <input type="text" name="code" class="form-control input-sm wr-code" th:attr="placeholder=#{URLPath}" />
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                    <button class="btn btn-primary" id="save-page" th:text="#{Save}">Save</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!--/#page-create-modal -->
                <script th:inline="javascript">
                    $(function() {
                        $('#wr-page-content').on('click', '#save-page', function(e) {
                            e.preventDefault();
                            var self = this;
                            $(self).button('loading');
                            var form = $(this).closest('form');
                            var data = {
                                parentId: $(':input[name="parentId"]', form).val(),
                                code: $(':input[name="code"]', form).val(),
                                title: $(':input[name="title"]', form).val(),
                                status: 'DRAFT'
                            };
                            $.ajax({
                                url: /*[[@{__$ADMIN_PATH__/pages.json}]]*/ '#',
                                type: 'post',
                                data: data,
                                success: function() {
                                    location = /*[[@{__$ADMIN_PATH__/pages/tree?created(query=${query})}]]*/ '#';
                                },
                                error: function(jqXHR) {
                                    $.each(jqXHR.responseJSON.fieldErrors, function(field, message) {
                                        var field = $(':input[name="' + field + '"]', form);
                                        $(field).closest('.form-group').addClass('has-error');
                                    });
                                    $(self).button('reset');
                                }
                            });
                        });
                        $('#wr-page-content').on('hidden.bs.modal', '#page-create-modal', function() {
                            $(this).removeData('bs.modal');
                        });
                    });
                </script>
                <!-- #page-delete-modal -->
                <div id="page-delete-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div id="page-delete-dialog" class="modal-dialog">
                        <form>
                            <div th:fragment="page-delete-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" th:text="#{DeletePage}">Delete Page</h4>
                                </div>
                                <div class="modal-body">
                                    <p th:text="#{MakeSureDelete}">Are you sure you want to delete?</p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal">Cancel</button>
                                    <button id="delete-page" class="btn btn-primary" th:attr="data-id=${targetId}" th:text="#{Delete}">Delete</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!--/#page-delete-modal -->
                <script th:inline="javascript">
                    $(function() {
                        $('#page-tree').nestedSortable({
                            forcePlaceholderSize: true,
                            handle: 'div',
                            helper:	'clone',
                            items: 'li',
                            opacity: .6,
                            placeholder: 'placeholder',
                            revert: 250,
                            tabSize: 25,
                            tolerance: 'pointer',
                            toleranceElement: '> div',
                            listType: 'ul',
                            isTree: true,
                            expandOnHover: 700
                            //							startCollapsed: true
                        });
                        $('#wr-page-content').on('sortupdate', '#page-tree', function() {
                            $('#update-page-sort').prop('disabled', false);
                            $('button', $(this)).prop('disabled', true);
                        });
                        $('.disclose').on('click', function() {
                            $(this).closest('li').toggleClass('mjs-nestedSortable-collapsed').toggleClass('mjs-nestedSortable-expanded');
                        })
                        $('#wr-page-content').on('click', '#delete-page', function(e) {
                            e.preventDefault();
                            var self = $(this);
                            self.button('loading');
                            /*[+
                             var url = [[@{__$ADMIN_PATH__/pages/}]] + self.data('id') + '.json';
                             +]*/
                            $.ajax({
                                url: url,
                                type: 'delete',
                                success: function() {
                                    $('#page-tree_' + self.data('id')).fadeOut(300, function() {
                                        location = /*[[@{__$ADMIN_PATH__/pages/tree?deleted(query=${query})}]]*/ '#';
                                    });
                                },
                                error: function() {
                                }
                            });
                        });
                    });
                </script>
            </div>
        </div>
    </div>
</page-tree>