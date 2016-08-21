<user-index>
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <div class="pull-left">
                <h1 th:text="#{Users}">Users</h1>
            </div>
            <div class="pull-right">
                <a th:href="@{__${ADMIN_PATH}__/users/invitations/index(query=${query})}" class="btn btn-primary btn-sm" style="margin-top: -3px;"><span class="glyphicon glyphicon-plus"></span> <span th:text="#{InviteNew}">ユーザーを招待</span></a>
            </div>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <section class="search-condition">
                <div class="search-condition-simple clearfix">
                    <form class="form-inline" method="get" th:action="@{/_admin/__${language}__/users/index}" th:object="${form}">
                        <input type="submit" style="visibility:hidden; width:0; height:0;"/>
                        <div class="form-group pull-left">
                            <div class="input-group keyword-search">
                                <input type="text" name="keyword" th:value="*{keyword}" class="form-control" th:attr="placeholder=#{Keywords}" />
                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="submit"><span class="glyphicon glyphicon-search"></span>
                                    </button>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>
            </section>
            <section class="search-result">
                <form method="post">
                    <input type="hidden" name="token" th:value="${token}" />
                    <div class="search-result-header clearfix">
                        <div class="btn-toolbar wr-bulk-action pull-left">
                            <div class="btn-group">
                                <a th:href="@{__${ADMIN_PATH}__/users/index(part=bulk-delete-form,query=${query})}" data-toggle="modal" data-target="#bulk-delete-modal" class="btn btn-default disabled"><span class="glyphicon glyphicon-trash"></span></a>
                            </div>
                        </div>
                        <div class="pagination-group pull-right">
                            <div class="pull-left pagination-summary"><span th:text="${pagination.numberOfFirstElement}"></span> - <span th:text="${pagination.numberOfLastElement}"></span> / <span th:text="${pagination.totalElements}"></span></div>
                            <div class="pull-right">
                                <ul class="pagination paginateon-sm">
                                    <li th:classappend="${pagination.hasPreviousPage() ? '' : 'disabled'}"><a th:href="@{__${ADMIN_PATH}__/users/index(page=${pagination.previousPageNumber})}" th:text="#{Prev}">Prev</a></li>
                                    <li th:each="p : ${pagination.getPageables(pageable)}" th:classappend="${p.pageNumber eq pagination.currentPageNumber ? 'active' : ''}"><a th:href="@{__${ADMIN_PATH}__/users/index(page=${p.pageNumber},size=${p.pageSize})}" th:text="${p.pageNumber + 1}"></a></li>
                                    <li th:classappend="${pagination.hasNextPage() ? '' : 'disabled'}"><a th:href="@{__${ADMIN_PATH}__/users/index(page=${pagination.nextPageNumber})}" th:text="#{Next}">Next</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover list">
                            <thead>
                                <tr>
                                    <th class="wr-tr-checkbox"><input type="checkbox" /></th>
                                    <th th:text="#{Name}">名前</th>
                                    <th th:text="#{LoginId}">ログインID</th>
                                    <th th:text="#{Email}">メールアドレス</th>
                                    <th th:text="#{Posts}" class="text-right">投稿記事数</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr th:each="user : ${users}" th:attr="data-href=@{__${ADMIN_PATH}__/users/describe(id=${user.id},query=${query})}" class="clickable">
                                    <td class="wr-tr-checkbox" style="width:40px"><input type="checkbox" name="ids" th:value="${user.id}" /></td>
                                    <td th:text="${user.name}"></td>
                                    <td th:text="${user.loginId}"></td>
                                    <td th:text="${user.email}"></td>
                                    <td th:text="${articleCounts.get(user.id)}?:0" class="text-right"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- #bulk-delete-modal -->
                    <div id="bulk-delete-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div id="bulk-delete-dialog" class="modal-dialog">
                            <div th:fragment="bulk-delete-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title">Delete Articles</h4>
                                </div>
                                <div class="modal-body">
                                    <p th:text="#{MakeSureDelete}">Are you sure you want to delete?</p>
                                    <div class="checkbox">
                                        <label><input type="checkbox" name="confirmed" value="true" /> <span th:text="#{Confirm}">Confirm</span></label>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                    <button class="btn btn-primary" th:attr="data-action=@{__${ADMIN_PATH}__/users/bulk-delete(query=${query})}" disabled="true" th:text="#{Delete}">Delete</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/#bulk-delete-modal -->
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function() {
                            $('#bulk-delete-modal').on('hidden.bs.modal', function() {
                                $(this).removeData('bs.modal');
                            });
                            $('#bulk-delete-modal').on('change', ':input[name="confirmed"]', function() {
                                var confirmed = $(this);
                                $('#bulk-delete-modal .btn-primary').prop('disabled', !confirmed.is(':checked'));
                            });
                            $('#wr-page-content .search-result').on('click', '[data-href]', function(e) {
                                if (!$(e.target).is(':checkbox') && !$(e.target).is('a')){
                                    window.location = $(e.target).closest('tr').data('href');
                                };
                            });
                            $('#wr-page-content .search-result').on('click', '[data-action]', function(e) {
                                var form = $(this).closest('form');
                                form.attr('action', $(this).data('action'));
                                form.submit();
                                e.preventDefault();
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox').shiftcheckbox({
                                checkboxSelector: ':checkbox',
                                selectAll: '.search-result th.wr-tr-checkbox'
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox').closest('td').click(function(e) {
                                e.stopPropagation();
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox :checkbox').change(function(e) {
                                var checked = $(this).prop('checked');
                                if (checked) {
                                    $(this).closest('tr').addClass('warning');
                                }
                                else {
                                    $(this).closest('tr').removeClass('warning');
                                }
                                var checkedSomeone = false;
                                $('#wr-page-content .search-result td.wr-tr-checkbox :checkbox').each(function(i, e) {
                                    if ($(e).prop('checked')) {
                                        checkedSomeone = true;
                                        return;
                                    }
                                });
                                if (checkedSomeone) {
                                    $('#wr-page-content .search-result .wr-bulk-action .btn').removeClass('disabled');
                                }
                                else {
                                    $('#wr-page-content .search-result .wr-bulk-action .btn').addClass('disabled');
                                }
                            });
                        });
                        // ]]>
                    </script>
                </form>
            </section>
        </div>
    </div>
</user-index>