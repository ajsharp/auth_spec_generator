require File.expand_path(File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper')

describe <%= controller_class_name %>Controller do
  describe "public actions" do
    describe "handling GET /<%= table_name %>" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.stub!(:find).and_return([@<%= file_name %>])
      end

      def do_get
        get :index
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render index template" do
        do_get
        response.should render_template('index')
      end

      it "should find all <%= table_name %>" do
        <%= class_name %>.should_receive(:find).with(:all).and_return([@<%= file_name %>])
        do_get
      end

      it "should assign the found <%= table_name %> for the view" do
        do_get
        assigns[:<%= table_name %>].should == [@<%= file_name %>]
      end
    end # end of GET /<%= table_name %>

    describe "handling GET /<%= table_name %>.xml" do
      before(:each) do
        @<%= file_name.pluralize %> = mock("Array of <%= class_name.pluralize %>", :to_xml => "XML")
        <%= class_name %>.stub!(:find).and_return(@<%= file_name.pluralize %>)
      end

      def do_get
        @request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should find all <%= table_name %>" do
        <%= class_name %>.should_receive(:find).with(:all).and_return(@<%= file_name.pluralize %>)
        do_get
      end

      it "should render the found <%= table_name %> as xml" do
        @<%= file_name.pluralize %>.should_receive(:to_xml).and_return("XML")
        do_get
        response.body.should == "XML"
      end
    end # end of GET /<%= table_name %>.xml

    describe "handling GET /<%= table_name %>/1" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
      end

      def do_get
        get :show, :id => "1"
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render show template" do
        do_get
        response.should render_template('show')
      end

      it "should find the <%= file_name %> requested" do
        <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
        do_get
      end

      it "should assign the found <%= file_name %> for the view" do
        do_get
        assigns[:<%= file_name %>].should equal(@<%= file_name %>)
      end
    end # end of GET /<%= table_name %>/1

    describe "handling GET /<%= table_name %>/1.xml" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>, :to_xml => "XML")
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
      end

      def do_get
        @request.env["HTTP_ACCEPT"] = "application/xml"
        get :show, :id => "1"
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should find the <%= file_name %> requested" do
        <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
        do_get
      end

      it "should render the found <%= file_name %> as xml" do
        @<%= file_name %>.should_receive(:to_xml).and_return("XML")
        do_get
        response.body.should == "XML"
      end
    end # end of GET /<%= table_name %>/1.xml
  end # end of public actions
  
  describe "restricted actions" do
    before(:each) do
      controller.stub!(:check_access).and_return(true)
    end
    
    describe "handling GET /<%= table_name %>/new" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
      end

      def do_get
        get :new
      end

      it "should verify user has access" do
        controller.should_receive(:check_access).and_return(true)
        do_get
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render new template" do
        do_get
        response.should render_template('new')
      end

      it "should create an new <%= file_name %>" do
        <%= class_name %>.should_receive(:new).and_return(@<%= file_name %>)
        do_get
      end

      it "should not save the new <%= file_name %>" do
        @<%= file_name %>.should_not_receive(:save)
        do_get
      end

      it "should assign the new <%= file_name %> for the view" do
        do_get
        assigns[:<%= file_name %>].should equal(@<%= file_name %>)
      end
    end # end of GET /<%= table_name %>/new

    describe "handling GET /<%= table_name %>/1/edit" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>)
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
      end

      def do_get
        get :edit, :id => "1"
      end

      it "should verify user has access" do
        controller.should_receive(:check_access).and_return(true)
        do_get
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render edit template" do
        do_get
        response.should render_template('edit')
      end

      it "should find the <%= file_name %> requested" do
        <%= class_name %>.should_receive(:find).and_return(@<%= file_name %>)
        do_get
      end

      it "should assign the found <%= class_name %> for the view" do
        do_get
        assigns[:<%= file_name %>].should equal(@<%= file_name %>)
      end
    end # end of GET /<%= table_name %>/1/edit

    describe "handling POST /<%= table_name %>" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1")
        <%= class_name %>.stub!(:new).and_return(@<%= file_name %>)
      end
      
      def do_post
        post :create, :<%= file_name %> => {}
      end
      
      it "should verify user has access" do
        controller.should_receive(:check_access).and_return(true)
        do_post
      end

      describe "with successful save" do
        before(:each) do
          @<%= file_name %>.should_receive(:save).and_return(true)
        end

        it "should create a new <%= file_name %>" do
          <%= class_name %>.should_receive(:new).with({}).and_return(@<%= file_name %>)
          do_post
        end

        it "should redirect to the new <%= file_name %>" do
          do_post
          response.should redirect_to(<%= table_name.singularize %>_url("1"))
        end
      end # end of successful save

      describe "with failed save" do
        before(:each) do
          @<%= file_name %>.should_receive(:save).and_return(false)
        end

        it "should re-render 'new'" do
          do_post
          response.should render_template('new')
        end
      end # end of failed save
    end # end of POST /<%= table_name %>

    describe "handling PUT /<%= table_name %>/1" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>, :to_param => "1")
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
      end
      
      def do_put
        put :update, :id => "1"
      end
      
      it "should verify user has access" do
        controller.should_receive(:check_access).and_return(true)
        do_put
      end

      describe "with successful update" do
        before(:each) do
          @<%= file_name %>.should_receive(:update_attributes).and_return(true)
        end

        it "should find the <%= file_name %> requested" do
          <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
          do_put
        end

        it "should update the found <%= file_name %>" do
          do_put
          assigns(:<%= file_name %>).should equal(@<%= file_name %>)
        end

        it "should assign the found <%= file_name %> for the view" do
          do_put
          assigns(:<%= file_name %>).should equal(@<%= file_name %>)
        end

        it "should redirect to the <%= file_name %>" do
          do_put
          response.should redirect_to(<%= table_name.singularize %>_url("1"))
        end
      end # end of successful update

      describe "with failed update" do
        before(:each) do
          @<%= file_name %>.should_receive(:update_attributes).and_return(false)
        end

        it "should re-render 'edit'" do
          do_put
          response.should render_template('edit')
        end
      end # end of failed update
    end # end of PUT /<%= table_name %>/1

    describe "handling DELETE /<%= table_name %>/1" do
      before(:each) do
        @<%= file_name %> = mock_model(<%= class_name %>, :destroy => true)
        <%= class_name %>.stub!(:find).and_return(@<%= file_name %>)
      end

      def do_delete
        delete :destroy, :id => "1"
      end
      
      it "should verify user has access" do
        controller.should_receive(:check_access).and_return(true)
        do_delete
      end

      it "should find the <%= file_name %> requested" do
        <%= class_name %>.should_receive(:find).with("1").and_return(@<%= file_name %>)
        do_delete
      end

      it "should call destroy on the found <%= file_name %>" do
        @<%= file_name %>.should_receive(:destroy)
        do_delete
      end

      it "should redirect to the <%= table_name %> list" do
        do_delete
        response.should redirect_to(<%= table_name %>_url)
      end
    end # end of DELETE /<%= table_name %>/1
  end # end of restricted actions
end
