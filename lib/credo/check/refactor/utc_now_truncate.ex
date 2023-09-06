defmodule Credo.Check.Refactor.UtcNowTruncate do
  use Credo.Check,
    id: "EX4032",
    base_priority: :high,
    explanations: [
      check: """
      Pass time unit to `{Naive}DateTime.utc_now` instead of composing with `{Naive}DateTime.truncate/2`.

      This should be refactored:

          DateTime.utc_now() |> DateTime.truncate(:second)

      to look like this:

          DateTime.utc_now(:second)

      Dito for `NaiveDateTime`.

      The reason for this is not just performance, because no separate function
      call is required, but also brevity of the resulting code.
      """
    ]

  @doc false
  def run(source_file, params \\ []) do
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  # DateTime.truncate(DateTime.utc_now(), _)
  # DateTime.truncate(DateTime.utc_now(_), _)
  # DateTime.truncate(DateTime.utc_now(_, _), _)
  defp traverse(
         {{:., meta, [{:__aliases__, _, [:DateTime]}, :truncate]}, _,
          [
            {{:., _, [{:__aliases__, _, [:DateTime]}, :utc_now]}, _, _},
            _
          ]} =
           ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # DateTime.utc_now() |> DateTime.truncate(_)
  # DateTime.utc_now(_) |> DateTime.truncate(_)
  # DateTime.utc_now(_, _) |> DateTime.truncate(_)
  defp traverse(
         {:|>, meta,
          [
            {{:., _, [{:__aliases__, _, [:DateTime]}, :utc_now]}, _, _},
            {{:., _, [{:__aliases__, _, [:DateTime]}, :truncate]}, _, [_]}
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # DateTime.truncate(_ |> DateTime.utc_now(), _)
  # DateTime.truncate(_ |> DateTime.utc_now(_), _)
  defp traverse(
         {{:., meta, [{:__aliases__, _, [:DateTime]}, :truncate]}, _,
          [
            {:|>, _,
             [
               _,
               {{:., _, [{:__aliases__, _, [:DateTime]}, :utc_now]}, _, _}
             ]},
            _
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # _ |> DateTime.utc_now() |> DateTime.truncate(_)
  # _ |> DateTime.utc_now(_) |> DateTime.truncate(_)
  defp traverse(
         {:|>, meta,
          [
            {:|>, _,
             [
               _,
               {{:., _, [{:__aliases__, _, [:DateTime]}, :utc_now]}, _, _}
             ]},
            {{:., _, [{:__aliases__, _, [:DateTime]}, :truncate]}, _, [_]}
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # NaiveDateTime.truncate(NaiveDateTime.utc_now(), _)
  # NaiveDateTime.truncate(NaiveDateTime.utc_now(_), _)
  # NaiveDateTime.truncate(NaiveDateTime.utc_now(_, _), _)
  defp traverse(
         {{:., meta, [{:__aliases__, _, [:NaiveDateTime]}, :truncate]}, _,
          [
            {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :utc_now]}, _, _},
            _
          ]} =
           ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # NaiveDateTime.utc_now() |> NaiveDateTime.truncate(_)
  # NaiveDateTime.utc_now(_) |> NaiveDateTime.truncate(_)
  # NaiveDateTime.utc_now(_, _) |> NaiveDateTime.truncate(_)
  defp traverse(
         {:|>, meta,
          [
            {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :utc_now]}, _, _},
            {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :truncate]}, _, [_]}
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # NaiveDateTime.truncate(_ |> NaiveDateTime.utc_now(), _)
  # NaiveDateTime.truncate(_ |> NaiveDateTime.utc_now(_), _)
  defp traverse(
         {{:., meta, [{:__aliases__, _, [:NaiveDateTime]}, :truncate]}, _,
          [
            {:|>, _,
             [
               _,
               {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :utc_now]}, _, _}
             ]},
            _
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  # _ |> NaiveDateTime.utc_now() |> NaiveDateTime.truncate(_)
  # _ |> NaiveDateTime.utc_now(_) |> NaiveDateTime.truncate(_)
  defp traverse(
         {:|>, meta,
          [
            {:|>, _,
             [
               _,
               {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :utc_now]}, _, _}
             ]},
            {{:., _, [{:__aliases__, _, [:NaiveDateTime]}, :truncate]}, _, [_]}
          ]} = ast,
         issues,
         issue_meta
       ) do
    new_issue = issue_for(issue_meta, meta[:line], "utc_now_truncate")
    {ast, issues ++ List.wrap(new_issue)}
  end

  defp traverse(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(
      issue_meta,
      message:
        "Pass time unit to `{Naive}DateTime.utc_now` instead of composing with `{Naive}DateTime.truncate/2`.",
      trigger: trigger,
      line_no: line_no
    )
  end
end
