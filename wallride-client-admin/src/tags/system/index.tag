<system-index>
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <h1 th:text="#{System}">System</h1>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="table-responsive">
                        <table class="table">
                            <colgroup>
                                <col class="col-sm-3" />
                                <col class="col-sm-9" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>Spring Profile</th>
                                    <td th:text="${system['spring.profiles.active']}">default</td>
                                </tr>
                                <tr>
                                    <th>Java Version</th>
                                    <td th:text="${system['java.version']}">1.7.0</td>
                                </tr>
                                <tr>
                                    <th>Java Vendor</th>
                                    <td th:text="${system['java.vendor']}">Oracle Corporation</td>
                                </tr>
                                <tr>
                                    <th>User Timezone</th>
                                    <td th:text="${system['user.timezone']}">User Timezone</td>
                                </tr>
                                <tr>
                                    <th>User Locale</th>
                                    <td><span th:text="${system['user.language']}">en</span>_<span th:text="${system['user.country']}">US</span></td>
                                </tr>
                                <tr>
                                    <th>Re-index</th>
                                    <td>
                                        <form th:action="@{__$ADMIN_PATH__/system/re-index}" class="form-horizontal" method="post">
                                            <div class="alert alert-success" th:if="${reIndex}">
                                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                                <span th:text="#{StartedReIndex}">Re-Index started</span>
                                            </div>
                                            <button class="btn btn-sm btn-primary ok" th:text="#{ReIndex}">Re-Index</button>
                                        </form>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Template Cache</th>
                                    <td>
                                        <form th:action="@{__$ADMIN_PATH__/system/clear-cache}" class="form-horizontal" method="post">
                                            <div class="alert alert-success" th:if="${clearCache}">
                                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                                <span th:text="#{StartedClearCache}">Clearing caches...</span>
                                            </div>
                                            <button class="btn btn-sm btn-primary ok" th:text="#{ClearCache}">Clear Cache</button>
                                        </form>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</system-index>