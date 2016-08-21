<comment-index>
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <div class="pull-left">
                <h1 th:text="#{Comments}">Comments</h1>
            </div>
        </div>
    </div>
    <div id="wr-page-content">
        <section class="search-condition">
            <div class="navbar">
                <div class="container-fluid">
                    <form id="search-form" class="navbar-form navbar-left" method="get" th:action="@{__${ADMIN_PATH}__/comments/index}" th:object="${form}">
                        <input type="text" name="keyword" th:value="*{keyword}" class="form-control" th:attr="placeholder=#{Keywords}"/>
                        <button class="btn btn-default" type="submit"><span class="glyphicon glyphicon-search"></span></button>
                    </form>
                </div>
            </div>
        </section>

        <div class="container-fluid">
            <div class="alert alert-success" th:if="${deletedComments ne null}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <span th:text="#{DeletedComments}">Comments Deleted.</span>
            </div>
            <div class="alert alert-success" th:if="${approvedComments ne null}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <span th:text="#{ApprovedComments}">Comments Approved.</span>
            </div>
            <div class="alert alert-success" th:if="${unapprovedComments ne null}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                <span th:text="#{UnapprovedComments}">Comments Unapproved.</span>
            </div>
            <section class="search-result">
                <form method="post">
                    <div class="search-result-header clearfix">
                        <div class="btn-toolbar pull-left">
                            <div class="wr-bulk-action btn-group">
                                <a th:href="@{__${ADMIN_PATH}__/comments/index(part=bulk-delete-form)}" data-toggle="modal" data-target="#bulk-delete-modal" class="btn btn-default disabled"><span class="glyphicon glyphicon-trash"></span></a>
                            </div>
                            <div class="wr-bulk-action btn-group">
                                <a th:href="@{__${ADMIN_PATH}__/comments/index(part=bulk-approve-form)}" data-toggle="modal" data-target="#bulk-approve-modal" class="btn btn-default disabled" th:text="#{Approve}">Approve</a>
                                <a th:href="@{__${ADMIN_PATH}__/comments/index(part=bulk-unapprove-form)}" data-toggle="modal" data-target="#bulk-unapprove-modal" class="btn btn-default disabled" th:text="#{Unapprove}">Unapprove</a>
                            </div>
                        </div>
                        <div class="pagination-group pull-right">
                            <div class="pull-left pagination-summary"><span th:text="${pagination.numberOfFirstElement}"></span> - <span th:text="${pagination.numberOfLastElement}"></span> / <span th:text="${pagination.totalElements}"></span></div>
                            <div class="pull-right">
                                <ul class="pagination paginateon-sm">
                                    <li th:classappend="${pagination.hasPreviousPage() ? '' : 'disabled'}"><a th:href="@{${pagination.url}(page=${pagination.previousPageNumber})}" th:text="#{Prev}">Prev</a></li>
                                    <li th:each="p : ${pagination.getPageables(pageable)}" th:classappend="${p.pageNumber eq pagination.currentPageNumber ? 'active' : ''}"><a th:href="@{${pagination.url}(page=${p.pageNumber})}" th:text="${p.pageNumber + 1}"></a></li>
                                    <li th:classappend="${pagination.hasNextPage() ? '' : 'disabled'}"><a th:href="@{${pagination.url}(page=${pagination.nextPageNumber})}" th:text="#{Next}">Next</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th class="wr-tr-checkbox" style="width:40px"><input type="checkbox"/></th>
                                    <th class="col-sm-2" th:text="#{Author}">Author</th>
                                    <th class="col-sm-6" th:text="#{Comment}">Comment</th>
                                    <th class="col-sm-2" th:text="#{Date}">Date</th>
                                    <th class="col-sm-2" th:text="#{Post}">Post</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr th:each="comment : ${comments}" th:classappend="${!comment.approved}? 'active'">
                                    <td class="wr-tr-checkbox" style="width:40px"><input type="checkbox" name="ids" th:value="${comment.id}" /></td>
                                    <td th:text="${comment.author}"></td>
                                    <td th:text="${comment.content}"></td>
                                    <td th:text="${#temporals.format(comment.date, 'yyyy/MM/dd (E) HH:mm', #locale)}"></td>
                                    <td><a th:href="@{__${ADMIN_PATH}__/posts/describe(id=${comment.post.id})}" th:text="${comment.post.title}">Post title</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function () {
                            $('#wr-page-content .search-result').on('click', '[data-href]', function (e) {
                                if (!$(e.target).is(':checkbox') && !$(e.target).is('a')) {
                                    window.location = $(e.target).closest('tr').data('href');
                                };
                            });
                            $('#wr-page-content .search-result').on('click', '[data-action]', function (e) {
                                var form = $(this).closest('form');
                                form.attr('action', $(this).data('action'));
                                form.submit();
                                e.preventDefault();
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox').shiftcheckbox({
                                checkboxSelector: ':checkbox',
                                selectAll: '.search-result th.wr-tr-checkbox'
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox').closest('td').click(function (e) {
                                e.stopPropagation();
                            });
                            $('#wr-page-content .search-result td.wr-tr-checkbox :checkbox').change(function (e) {
                                var checked = $(this).prop('checked');
                                if (checked) {
                                    $(this).closest('tr').addClass('warning');
                                } else {
                                    $(this).closest('tr').removeClass('warning');
                                }
                                var checkedCount = $('#wr-page-content .search-result td.wr-tr-checkbox :checkbox:checked').length;
                                if (checkedCount == 0) {
                                    $('#wr-page-content .search-result .btn-toolbar .btn').addClass('disabled');
                                }
                                if (checkedCount >= 1) {
                                    $('#wr-page-content .search-result .wr-bulk-action .btn').removeClass('disabled');
                                }
                            });
                        });
                        // ]]>
                    </script>
                    <!-- #bulk-delete-modal -->
                    <div id="bulk-delete-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div id="bulk-delete-dialog" class="modal-dialog">
                            <div th:fragment="bulk-delete-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" th:text="#{DeleteComment}">Delete Comments</h4>
                                </div>
                                <div class="modal-body">
                                    <p th:text="#{MakeSureDelete}">Are you sure you want to delete?</p>
                                    <div class="checkbox">
                                        <label><input type="checkbox" name="confirmed" value="true"/> <span th:text="#{Confirm}">Confirm</span></label>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                    <button class="btn btn-primary" th:attr="data-action=@{__${ADMIN_PATH}__/comments/bulk-delete}" disabled="true" th:text="#{Delete}">Delete</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/#bulk-delete-modal -->
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function () {
                            $('#bulk-delete-modal').on('change', ':input[name="confirmed"]', function () {
                                var confirmed = $(this);
                                $('#bulk-delete-modal .btn-primary').prop('disabled', !confirmed.is(':checked'));
                            });
                            $('#bulk-delete-modal').on('hidden.bs.modal', function () {
                                $(this).removeData('bs.modal');
                            });
                        });
                        // ]]>
                    </script>
                    <!-- #bulk-approve-modal -->
                    <div id="bulk-approve-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div id="bulk-approve-dialog" class="modal-dialog">
                            <div th:fragment="bulk-approve-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" th:text="#{ApproveComment}">Approve Comment</h4>
                                </div>
                                <div class="modal-body">
                                    <p th:text="#{MakeSureApprove}">Are you sure you want to approve?</p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                    <button class="btn btn-primary" th:attr="data-action=@{__${ADMIN_PATH}__/comments/bulk-approve}" th:text="#{Approve}">Approve</button>
                                </div>
                                <script>
                                    $(function () {
                                        $(':input[name="date"]').datetimepicker({});
                                    });
                                </script>
                            </div>
                        </div>
                    </div>
                    <!--/#bulk-approve-modal -->
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function () {
                            $('#bulk-approve-modal').on('hidden.bs.modal', function () {
                                $(this).removeData('bs.modal');
                            });
                        });
                        // ]]>
                    </script>
                    <!-- #bulk-unapprove-modal -->
                    <div id="bulk-unapprove-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div id="bulk-unapprove-dialog" class="modal-dialog">
                            <div th:fragment="bulk-unapprove-form" class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" th:text="#{UnapproveComment}">Unapprove Comment</h4>
                                </div>
                                <div class="modal-body">
                                    <p th:text="#{MakeSureUnapprove}">Are you sure you want to unapprove?</p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                    <button class="btn btn-primary" th:attr="data-action=@{__${ADMIN_PATH}__/comments/bulk-unapprove}" th:text="#{Unapprove}">Unapprove</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--/#bulk-unapprove-modal -->
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function () {
                            $('#bulk-unapprove-modal').on('hidden.bs.modal', function () {
                                $(this).removeData('bs.modal');
                            });
                        });
                        // ]]>
                    </script>
                </form>
            </section>
        </div>
    </div>
</comment-index>