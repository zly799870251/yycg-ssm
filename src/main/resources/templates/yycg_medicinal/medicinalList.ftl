﻿<!DOCTYPE HTML>
<html>
<head>
  <#include "../public/classform.ftl">
  <title>药品采购系统-药品目录</title>
</head>
<body>
<#include "../public/childPageTopMenu.ftl">

<div class="page-container">
  <div class="cl pd-5 bg-1 bk-gray mt-20">
    <span class="l">
      <a href="javascript:;" onclick="datadel()" class="btn btn-danger radius">
        <i class="Hui-iconfont">&#xe6e2;</i> 批量删除
      </a>
      <a class="btn btn-primary radius" data-title="添加资讯" data-href="article-add.html" onclick="Hui_admin_tab(this)"
         href="javascript:;">
        <i class="Hui-iconfont">&#xe600;</i> 添加资讯
      </a>
    </span>
    <span class="r">共有数据：<strong>54</strong> 条</span>
  </div>

  <div class="mt-20">
    <table class="table table-border table-bordered table-bg table-hover table-sort">
      <thead>
      <tr class="text-c">
        <th width="25"><input type="checkbox" name="" value=""></th>
        <th width="80">流水号</th>
        <th width="100">通用名</th>
        <th width="40">剂型</th>
        <th width="40">规格</th>
        <th width="60">转换系数</th>
        <th width="90">生产企业</th>
        <th width="60">商品名</th>
        <th width="40">中标价</th>
        <th width="90">单位</th>
        <th width="60">质量层次</th>
        <th width="60">药品类别</th>
        <th width="80">药品交易状态</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <%if (medicinals){
          var medicinals = JSON.parse(list);
          for(medicinal in medicinals) { %>
            <tr class="text-c">
              <td><input type="checkbox" value="" name=""></td>
              <td><%= medicinal.serialNumber%></td>
              <td><%= medicinal.genericName%></td>
              <td><%= medicinal.dosageForm%></td>
              <td><%= medicinal.specification%></td>
              <td><%= medicinal.conversionFactor%></td>
              <td><%= medicinal.manuenterName%></td>
              <td><%= medicinal.commodityName%></td>
              <td><%= medicinal.bidPrice%></td>
              <td><%= medicinal.company%></td>
              <td><%= medicinal.qualityLevel%></td>
              <td><%= medicinal.drugCategory%></td>
              <td class="td-status">
                <span class="label label-success radius"><%= medicinal.drugTradingStatus%></span>
              </td>
              <td class="f-14 td-manage">
                <a style="text-decoration:none" class="ml-5" onClick="article_edit('资讯编辑','article-add.html','10001')"
                   href="javascript:;" title="修改">
                  <i class="Hui-iconfont">&#xe6df;</i>
                </a>
                <a style="text-decoration:none" class="ml-5" onClick="article_del(this,'10001')" href="javascript:;"
                   title="删除">
                  <i class="Hui-iconfont">&#xe6e2;</i>
                </a>
              </td>
            </tr>
      <% }}%>
      </tbody>
    </table>
  </div>
</div>

<#include "../public/footer.ftl"/>

<!--请在下方写此页面业务相关的脚本-->
<script type="text/javascript" src="${request.contextPath}/templates/lib/My97DatePicker/4.8/WdatePicker.js"></script>
<script type="text/javascript" src="${request.contextPath}/templates/lib/datatables/1.10.0/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="${request.contextPath}/templates/lib/laypage/1.2/laypage.js"></script>
<script type="text/javascript">
  $('.table-sort').dataTable({
    "aaSorting": [[1, "desc"]],//默认第几个排序
    "bStateSave": true,//状态保存
    "aoColumnDefs": [
      //{"bVisible": false, "aTargets": [ 3 ]} //控制列的隐藏显示
      {"orderable": false, "aTargets": [0, 8]}// 不参与排序的列
    ]
  });

  /*资讯-添加*/
  function article_add(title, url, w, h) {
    var index = layer.open({
      type: 2,
      title: title,
      content: url
    });
    layer.full(index);
  }
  /*资讯-编辑*/
  function article_edit(title, url, id, w, h) {
    var index = layer.open({
      type: 2,
      title: title,
      content: url
    });
    layer.full(index);
  }
  /*资讯-删除*/
  function article_del(obj, id) {
    layer.confirm('确认要删除吗？', function (index) {
      $.ajax({
        type: 'POST',
        url: '',
        dataType: 'json',
        success: function (data) {
          $(obj).parents("tr").remove();
          layer.msg('已删除!', {icon: 1, time: 1000});
        },
        error: function (data) {
          console.log(data.msg);
        },
      });
    });
  }

  /*资讯-审核*/
  function article_shenhe(obj, id) {
    layer.confirm('审核文章？', {
        btn: ['通过', '不通过', '取消'],
        shade: false,
        closeBtn: 0
      },
      function () {
        $(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="article_start(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
        $(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
        $(obj).remove();
        layer.msg('已发布', {icon: 6, time: 1000});
      },
      function () {
        $(obj).parents("tr").find(".td-manage").prepend('<a class="c-primary" onClick="article_shenqing(this,id)" href="javascript:;" title="申请上线">申请上线</a>');
        $(obj).parents("tr").find(".td-status").html('<span class="label label-danger radius">未通过</span>');
        $(obj).remove();
        layer.msg('未通过', {icon: 5, time: 1000});
      });
  }
  /*资讯-下架*/
  function article_stop(obj, id) {
    layer.confirm('确认要下架吗？', function (index) {
      $(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="article_start(this,id)" href="javascript:;" title="发布"><i class="Hui-iconfont">&#xe603;</i></a>');
      $(obj).parents("tr").find(".td-status").html('<span class="label label-defaunt radius">已下架</span>');
      $(obj).remove();
      layer.msg('已下架!', {icon: 5, time: 1000});
    });
  }

  /*资讯-发布*/
  function article_start(obj, id) {
    layer.confirm('确认要发布吗？', function (index) {
      $(obj).parents("tr").find(".td-manage").prepend('<a style="text-decoration:none" onClick="article_stop(this,id)" href="javascript:;" title="下架"><i class="Hui-iconfont">&#xe6de;</i></a>');
      $(obj).parents("tr").find(".td-status").html('<span class="label label-success radius">已发布</span>');
      $(obj).remove();
      layer.msg('已发布!', {icon: 6, time: 1000});
    });
  }
  /*资讯-申请上线*/
  function article_shenqing(obj, id) {
    $(obj).parents("tr").find(".td-status").html('<span class="label label-default radius">待审核</span>');
    $(obj).parents("tr").find(".td-manage").html("");
    layer.msg('已提交申请，耐心等待审核!', {icon: 1, time: 2000});
  }

</script>
</body>
</html>
